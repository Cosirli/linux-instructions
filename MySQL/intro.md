# Why do we need Databases?

- Temporary, resident in memory -> **Persistency**

file vs db:

- convenience to CRUD - db
- security reasons - db
- dotfiles? file

Other usage: Caching (like MongoDB)

# Models

## Hierarchical Model

A directed tree.

Problems: How to search (efficiency)? How to update (inconsistency)?

## Network Model

Nodes in a graph.

Pros: resolved the consistency problem
Problems: Too much data related, it costs to navigate.

## Relational Model

All data are represented in terms of _tuples_, grouped into _relations_

Purpose: To provide a _declarative_ method for specifying data and queries.

### Basics

Row: Tuple (n values, each corresponding to an attribute. n: the relation's degree/arity)

Column: Attribute (name + type/domain)

Relation: Heading + Body

- Heading: a set of attributes
- Body: a set of tuples ()

Relations are represented by _relational variables_ or _relvars_

A database is a collection of relations

### Constraints

A set of boolean expressions. If all constraints evaluate as true, the database is _consistent_; otherwise, _inconsistent_

Two special constraints: **keys** and **foreign keys**

# SQL

classification:

- DDL Define -> create database, table, field ...
- DML Manipulation -> data CRUD.
- DQL Query -> search for records.
- DCL Control -> permission control.

DDL - create alter drop show
DML - insert update delete select
