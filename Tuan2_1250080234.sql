SELECT table_name FROM user_tables;
SELECT * FROM regions;
SELECT * FROM countries;
SELECT * FROM locations;
SELECT * FROM departments;
SELECT * FROM jobs;
SELECT * FROM employees;
SELECT * FROM job_history;
--Câu 1: Li?t kê last_name và salary c?a nhân viên có salary > 12.000$
select last_name, salary 
from employees
where salary > 12000;
--Câu 2: Nhân viên có salary < 5.000$ HO?C > 12.000$
select last_name, salary 
from employees
where salary < 5000 OR salary > 12000;
--Câu 3: last_name, job_id, hire_date t? 20/02/1998 ð?n 01/05/1998, s?p tãng d?n theo ngày
select last_name, job_id, hire_date
from employees
where hire_date BETWEEN TO_DATE('20/02/1998','DD/MM/YYYY') AND TO_DATE('01/05/1998','DD/MM/YYYY')
ORDER BY hire_date ASC;
--Câu 4: Nhân viên ph?ng 20 và 50: last_name, department_id, s?p x?p theo tên
select last_name, department_id
from employees
where department_id IN (20,50)
ORDER BY last_name ASC;
--Câu 5: Nhân viên ðý?c tuy?n trong nãm 1994
select last_name, hire_date
from employees
WHERE TO_CHAR(hire_date,'yyyy') = '1994'
--Câu 6: Nhân viên không có ngý?i qu?n l? (manager_id là NULL)
select last_name, job_id
from employees
where manager_id IS NULL;
--Câu 7: Nhân viên ðý?c hý?ng hoa h?ng (commission_pct), s?p x?p gi?m d?n theo lýõng và hoa h?ng
select last_name, salary, commission_pct
from employees
where commission_pct IS NOT NULL
ORDER BY salary DESC, commission_pct DESC;
--Câu 8: Nhân viên có k? t? th? 3 trong last_name là 'a'
select last_name
from employees
where last_name LIKE '__a%';
--Câu 9: Nhân viên mà last_name ch?a c? ch? 'a' và ch? 'e'
select last_name
from employees
where last_name LIKE '%a%'AND last_name LIKE '%e%';
--Câu 10: Nhân viên làm 'Sales Representative' HO?C 'Stock Clerk' và salary khác 2.500$, 3.500$, 7.000$
select last_name, salary, job_id
from employees
where job_id IN('SA_REP', 'ST_CLERK') AND
salary NOT IN(2500, 3500, 7000);
--Câu 11: employee_id, last_name, lýõng tãng 15% (làm tr?n hàng ðõn v?), ð?t alias 'New Salary'
select last_name, employee_id, ROUND(salary * 1.15,0) AS "New Salary"
from employees
--Câu 12: Tên nhân viên + chi?u dài tên, b?t ð?u b?ng J/A/L/M, dùng INITCAP, s?p tãng d?n theo tên
select INITCAP(last_name) AS "Ten Nhan Vien",
LENGTH(last_name) AS "Chieu Dai"
from employees
where SUBSTR(last_name,1,1) IN('J','A','L','M')
ORDER BY last_name ASC;
--Câu 13: Th?i gian làm vi?c tính theo tháng (MONTHS_BETWEEN), s?p tãng d?n
select last_name, TRUNC(MONTHS_BETWEEN(SYSDATE,hire_date)) AS "So Thang Lam Viec"
from employees
ORDER BY MONTHS_BETWEEN(SYSDATE,hire_date) ASC;
--Câu 14: Ð?nh d?ng k?t qu?: '<last_name> earns <salary> monthly but wants <3×salary>';
select last_name || 'earns'
|| TO_CHAR(salary, '$99,999') || 'monthly but wants'
|| TO_CHAR(salary*3, '$99,999') AS "Dream Salaries"
from employees;
--Câu 15: Tên nhân viên và m?c hoa h?ng; n?u không có hi?n th? 'No commission'
select last_name, NVL(TO_CHAR(commission_pct), 'No commission') AS "Comsission"
from employees;
--Câu 16: Hi?n th? job_id và GRADE: AD_PRES=A, ST_MAN=B, IT_PROG=C, SA_REP=D,ST_CLERK=E, c?n l?i=0
select job_id,
DECODE(job_id,
'AD_PRES','A',
'ST_MAN','B',
'IT_PROG','C',
'SA_REP','D',
'ST_CLERK','E',
'0') AS "GRADE"
from employees;
--Câu 17: Tên nhân viên, m? ph?ng, tên ph?ng c?a nhân viên làm t?i thành ph? Toronto
select e.last_name, e.department_id, d.department_name
from employees e, departments d, locations l
where e.department_id = d.department_id 
AND d.location_id  = l.location_id
AND UPPER(l.city) = 'TORONTO';
--Câu 18: M? NV, tên NV, m? qu?n l?, tên qu?n l? — Self Join
select e.employee_id AS "Ma NV",
e.last_name AS "Ten NV",
m.employee_id AS "Ma Quan Ly",
m.last_name AS "Ten Quan Ly"
from employees e, employees m
where e.manager_id = e.employee_id
--Câu 19: Danh sách nhân viên làm vi?c cùng ph?ng ban
select e1.last_name AS "Nhan vien 1",
e2.last_name AS "Nhan vien 2",
e1.department_id AS "Phong ban"
from employees e1, employees e2
where e1.department_id = e2.department_id AND 
e1.employee_id < e2.employee_id
ORDER BY e1.department_id, e1.last_name;
--Câu 20: Nhân viên ðý?c tuy?n d?ng SAU nhân viên 'Davies'
select last_name, hire_date
from employees
where hire_date > (select hire_date
from employees
where last_name = 'Davies');
--Câu 21: Nhân viên ðý?c tuy?n TRÝ?C ngý?i qu?n l? c?a h?
select e.last_name AS "Nhan vien",
e.hire_date AS "Ngay vao",
m.last_name AS "Quan ly",
m.hire_date AS "Quan ly vao"
from employees e, employees m
where e.manager_id = m.employee_id 
AND e.hire_date < m.hire_date;
--Câu 22: Lýõng th?p nh?t, cao nh?t, trung b?nh, t?ng lýõng c?a t?ng lo?i công vi?c
select job_id,
MIN(salary) AS "Luong thap nhat",
MAX(salary) AS "Luong cao nhat",
ROUND(AVG(salary),2) AS "Luong trung binh",
SUM(salary) AS "Tong luong"
from employees
GROUP BY job_id
ORDER By job_id;
--Câu 23: M? ph?ng, tên ph?ng, s? lý?ng nhân viên t?ng ph?ng + th?ng kê tuy?n d?ng theo nãm 1995–1998
--A: S? lý?ng nhân viên t?ng ph?ng:
select d.department_id, d.department_name, COUNT(e.employee_id) AS "So nhan vien"
from departments d LEFT JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY d.department_id;
--B: Th?ng kê tuy?n d?ng theo t?ng nãm:
select COUNT(*) AS "Tong NV",
SUM(CASE WHEN TO_CHAR(hire_date,'YYYY')='1995' THEN 1 ELSE 0 END) AS "Nam 1995",
SUM(CASE WHEN TO_CHAR(hire_date,'YYYY')='1996' THEN 1 ELSE 0 END) AS "Nam 1996",
SUM(CASE WHEN TO_CHAR(hire_date,'YYYY')='1997' THEN 1 ELSE 0 END) AS "Nam 1997",
SUM(CASE WHEN TO_CHAR(hire_date,'YYYY')='1998' THEN 1 ELSE 0 END) AS "Nam 1998"
from employees;
--Câu 25: Tên và hire_date c?a nhân viên làm vi?c cùng ph?ng v?i 'Zlotkey'
select last_name, hire_date
from employees
where department_id =(select department_id
from employees
where last_name = 'Zlotkey')
AND last_name <> 'Zlotkey';
--Câu 26: Tên, m? ph?ng, m? công vi?c c?a nhân viên thu?c ph?ng ? location_id = 1700
select last_name, department_id, job_id
from employees
where department_id IN(select department_id
from departments
where location_id = 1700);
--Câu 27: Danh sách nhân viên có ngý?i qu?n l? tên 'King'
select last_name, manager_id
from employees
where manager_id IN(select employee_id
from employees
where last_name = 'King');
--Câu 28: Nhân viên có salary > m?c trung b?nh VÀ làm cùng ph?ng v?i nhân viên có last_name k?t thúc b?ng 'n'
select last_name, salary, department_id
from employees
where salary >( select AVG(salary)
from employees)
AND department_id IN( select department_id
from employees
where last_name LIKE '%n');
--Câu 29: M? và tên ph?ng ban có ít hõn 3 nhân viên
select department_id, department_name
from departments d
where (select COUNT(*) from employees e
where e.department_id = d.department_id) < 3
ORDER BY department_id;
--Câu 30: Ph?ng ban ðông nhân viên nh?t và ít nhân viên nh?t
select department_id, COUNT(*) AS "So nhan vien", 'Dong nhat' AS "Loai"
from employees
GROUP BY department_id
HAVING COUNT(*) = ( select MAX(COUNT(*)) from employees GROUP BY department_id)
UNION ALL
select department_id, COUNT(*), 'It nhat' 
from employees
GROUP BY department_id
HAVING COUNT(*) =  ( select MIN(COUNT(*)) from employees GROUP BY department_id);
--Câu 31: Nhân viên ðý?c tuy?n vào ngày trong tu?n có s? lý?ng tuy?n d?ng ðông nh?t
select last_name, hire_date,
TO_CHAR(hire_date,'Day') AS "Thu trong tuan"
from employees
where TO_CHAR(hire_date,'Day') IN (
select TO_CHAR(hire_date,'Day')
from employees
GROUP BY TO_CHAR(hire_date,'Day')
HAVING COUNT(*) = (
Select MAX(COUNT(*))
from employees
GROUP BY TO_CHAR(hire_date,'Day')
)
);
--Câu 32: 3 nhân viên có lýõng cao nh?t
select last_name, salary
from (select last_name, salary
from employees
ORDER BY salary DESC)
where ROWNUM <= 3;
--Câu 33: Nhân viên ðang làm vi?c ? ti?u bang 'California'
select e.last_name, e.department_id
from employees e,
departments d, 
locations l
where e.department_id = d.department_id
AND d.location_id = l.location_id 
AND UPPER(l.state_province) = 'CALIFORNIA';
--Câu 34: C?p nh?t last_name c?a nhân viên có employee_id = 3 thành 'Drexler'
-- Kiem tra truoc
SELECT employee_id, last_name FROM employees WHERE employee_id = 3;
-- Cap nhat
UPDATE employees
SET last_name = 'Drexler'
WHERE employee_id = 3;
COMMIT;
-- Xac nhan sau khi cap nhat
SELECT employee_id, last_name FROM employees WHERE employee_id = 3;
--Câu 35: Nhân viên có salary th?p hõn m?c trung b?nh c?a ph?ng ban m?nh
SELECT e1.last_name, e1.salary, e1.department_id
FROM employees e1
WHERE e1.salary< (SELECT AVG(e2.salary)
FROM employees e2
WHERE e2.department_id = e1.department_id)
ORDER BY e1.department_id;
--Câu 36: Tãng thêm 100$ cho nhân viên có salary <900$
-- Kiem tra truoc: xem ai bi anh huong
SELECT employee_id, last_name, salary
FROM employees
WHERE salary< 900;

-- Tang luong
UPDATE employees
SET salary = salary + 100
WHERE salary < 900;

COMMIT;
--Câu 37: Xóa ph?ng ban có department_id = 500
-- Kiem tra: co nhan vien trong phong 500 khong?
SELECT COUNT(*) FROM employees WHERE department_id = 500;
-- Truong hop 1: Phong trong (khong co nhan vien)
DELETE FROM departments WHERE department_id = 500;
COMMIT;

-- Truong hop 2: Phong co nhan vien -&gt; phai xu ly truoc
UPDATE employees SET department_id = NULL WHERE department_id = 500;
DELETE FROM departments WHERE department_id = 500;
COMMIT;
--Câu 38: Xóa các ph?ng ban chýa có nhân viên nào
-- Kiem tra truoc
SELECT department_id, department_name FROM departments
WHERE department_id NOT IN (
SELECT DISTINCT department_id FROM employees
WHERE department_id IS NOT NULL
);

-- Thuc hien xoa
DELETE FROM departments
WHERE department_id NOT IN (
SELECT DISTINCT department_id FROM employees
WHERE department_id IS NOT NULL
);
COMMIT;
