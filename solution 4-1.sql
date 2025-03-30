WITH RECURSIVE EmployeeHierarchy AS (
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM
        Employees e
    WHERE
        e.EmployeeID = 1

    UNION ALL

    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM
        Employees e
    JOIN
        EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
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
    ) AS TaskNames
FROM
    EmployeeHierarchy eh
JOIN
    Departments d ON eh.DepartmentID = d.DepartmentID
JOIN
    Roles r ON eh.RoleID = r.RoleID
ORDER BY
    EmployeeName;
