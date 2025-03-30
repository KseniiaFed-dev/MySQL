WITH RECURSIVE EmployeeHierarchy AS (
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID,
        1 AS HierarchyLevel 
    FROM
        Employees e
    WHERE
        e.RoleID = (SELECT RoleID FROM Roles WHERE RoleName = 'Менеджер')
        AND EXISTS (SELECT 1 FROM Employees sub WHERE sub.ManagerID = e.EmployeeID) 

    UNION ALL

    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID,
        eh.HierarchyLevel + 1
    FROM
        Employees e
    JOIN
        EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
),
SubordinateCounts AS (
    SELECT
        eh.EmployeeID,
        COUNT(*) AS TotalSubordinates
    FROM
        EmployeeHierarchy eh
    GROUP BY
        eh.EmployeeID
)
SELECT
    eh.EmployeeID,
    eh.Name AS EmployeeName,
    eh.ManagerID,
    d.DepartmentName,
    r.RoleName,
    (
        SELECT GROUP_CONCAT(p.ProjectName, ', ')
        FROM Projects p
        WHERE p.DepartmentID = eh.DepartmentID
    ) AS ProjectNames,
    (
        SELECT GROUP_CONCAT(t.TaskName, ', ')
        FROM Tasks t
        WHERE t.AssignedTo = eh.EmployeeID
    ) AS TaskNames,
    COALESCE(sc.TotalSubordinates -1, 0) AS TotalSubordinates  
FROM
    EmployeeHierarchy eh
JOIN
    Departments d ON eh.DepartmentID = d.DepartmentID
JOIN
    Roles r ON eh.RoleID = r.RoleID
LEFT JOIN
    SubordinateCounts sc ON eh.EmployeeID = sc.EmployeeID
WHERE eh.ManagerID IS NOT NULL
AND eh.EmployeeID IN (SELECT EmployeeID FROM EmployeeHierarchy)  
ORDER BY
    EmployeeName;
