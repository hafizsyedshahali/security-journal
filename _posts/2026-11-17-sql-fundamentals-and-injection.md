---
title: "Cyber Security 101, Part 11: SQL Fundamentals and SQL Injection"
date: 2026-11-17 14:00:00 +0500
categories: [Daily Log, Cyber Security 101]
tags: [sql, sql-injection, sqlmap, databases, tryhackme]
---

I've written plenty of SQL in my data work, so the fundamentals room was revision. But seeing it from the attacker's side, and then using SQLMap, put the familiar queries in a new light. SQL injection is still one of the most common and damaging web vulnerabilities.

## Database 101

A **relational database** stores data in **tables** made of rows and columns, like a spreadsheet. A **database management system (DBMS)** such as MySQL, PostgreSQL or Microsoft SQL Server runs the database and answers queries written in **SQL (Structured Query Language)**.

## Database and table statements

```sql
CREATE DATABASE shop;
USE shop;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50),
    password VARCHAR(255)
);
```

- **CREATE DATABASE** makes a new database
- **CREATE TABLE** defines a table and its columns
- a **PRIMARY KEY** uniquely identifies each row

## CRUD operations

CRUD is the four basic things you do with data: Create, Read, Update, Delete.

```sql
INSERT INTO users (username, password) VALUES ('alice', 'hash');   -- Create
SELECT * FROM users;                                               -- Read
UPDATE users SET password = 'newhash' WHERE username = 'alice';    -- Update
DELETE FROM users WHERE username = 'alice';                        -- Delete
```

## Clauses, operators and functions

**Clauses** refine a query:

```sql
SELECT username FROM users WHERE id = 5;
SELECT * FROM users ORDER BY username ASC;
SELECT * FROM products LIMIT 10;
SELECT country, COUNT(*) FROM users GROUP BY country;
```

**Operators** build conditions: `=`, `!=`, `<`, `>`, `LIKE` (pattern matching with `%`), `AND`, `OR`, `IN`, `BETWEEN`.

**Functions** work on values: `COUNT()`, `SUM()`, `AVG()`, `MAX()`, `MIN()`, and text functions like `CONCAT()` and `UPPER()`.

## How SQL injection happens

The danger appears when an application builds a query by gluing user input straight into it. Imagine a login that does this:

```sql
SELECT * FROM users WHERE username = 'INPUT' AND password = 'INPUT';
```

If the username field isn't handled safely and a user types:

```
' OR '1'='1
```

the query becomes:

```sql
SELECT * FROM users WHERE username = '' OR '1'='1' AND password = '';
```

Because `'1'='1'` is always true, the condition passes and the attacker can log in without a valid password. That's **SQL injection (SQLi)**: user input changing the meaning of the query instead of being treated as plain data.

## Types of SQL injection

- **In-band:** the results come back on the same page.
  - **Error-based:** the attacker forces database errors that leak information.
  - **Union-based:** the `UNION` keyword adds the attacker's own `SELECT` to pull data from other tables.
- **Blind:** the page doesn't show results directly, so the attacker infers data from the application's behaviour.
  - **Boolean-based:** a condition makes the page respond differently for true vs false.
  - **Time-based:** a condition makes the database pause (for example `SLEEP(5)`), and the delay reveals the answer.

## The fix: parameterised queries

The real defence isn't blocking certain characters; it's never mixing code and data. **Parameterised queries (prepared statements)** send the query and the user's input separately, so the input can never change the query's structure:

```python
cursor.execute("SELECT * FROM users WHERE username = ?", (user_input,))
```

Here `user_input` is always treated as a value, never as SQL. Input validation and least-privilege database accounts add further layers.

## SQLMap

**SQLMap** automates finding and exploiting SQL injection. For a defender, it's useful to know what it does, because its traffic is very recognisable in logs.

```bash
sqlmap -u "http://site.thm/item?id=1"               # test a parameter
sqlmap -u "http://site.thm/item?id=1" --dbs          # list databases
sqlmap -u "http://site.thm/item?id=1" -D shop --tables
sqlmap -u "http://site.thm/item?id=1" -D shop -T users --dump
```

- `-u` is the target URL
- `--dbs`, `--tables`, `--columns` enumerate the structure
- `--dump` extracts data
- `--batch` accepts default answers without prompting

SQLMap sends large numbers of oddly-shaped requests to one parameter, often with SQL keywords, quotes and `SLEEP()` in them. In web server logs that pattern stands out clearly.

## Why this matters for a SOC engineer

SQL injection appears in web logs as suspicious query strings: single quotes, `UNION SELECT`, `OR 1=1`, `SLEEP(`. Recognising these, and knowing whether a WAF blocked them or the app returned a 200, is part of triaging web alerts. Knowing the fix also lets a SOC give useful advice back to developers instead of just reporting the alert.

## Questions I should be able to answer

- What are the four CRUD operations and their SQL statements?
- Explain how `' OR '1'='1` bypasses a login.
- What's the difference between in-band, union-based and blind SQL injection?
- What is time-based blind injection?
- Why do parameterised queries stop injection?
- What does SQLMap traffic look like in logs?

## Next

Tonight: Burp Suite, the tool for intercepting and manipulating web requests.
