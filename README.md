# pickem_db
MySQL Database scripts for creating Pickem DB


## Approach
1. Identify desired data elements from each source website and normalize data model to mitigate redundancy ([Data Normalization Draft Doc](https://docs.google.com/spreadsheets/d/12aBpKssCciR3sFBb1Mrp15PZSPBCHbsKBGePMRpX4PY/edit?usp=sharing))
2. Create Entity Relationship Diagram for Pickem database ([CFB Pickem ERD](https://lucid.app/lucidchart/b23cbf7a-b9f9-4ce6-b310-3fb8cbcc6329/edit?viewport_loc=-1207%2C-1018%2C3577%2C2203%2C0_0&invitationId=inv_fb883cc0-8449-4625-9a2e-8be28ce6ef22))
3. Develop `PROC_CREATE_TABLES` procedure to instantiate each database table (if they do not exist)
4. Develop `PROC_CREATE_VIEWS` procedure to instantiate each database view (if they do not exist)
5. Develop `PROC_DELETE_DATA` procedure to delete all table data without violating foreign key constraints
6. Develop `PROC_CREATE_USER` procedure to insert new user and picks records into the database
7. Develop `PROC_UPDATE_USER` procedure to execute update on USERS table for given USER_ID
8. Develop `PROC_SUBMIT_PICK` procedure to execute update on PICKS table for given USER_ID and GAME_ID
9. Develop `PROC_DROP_DB` procedure to drop all database objects
10. Develop `PROC_CREATE_DB` procedure to create all database objects
11. Instantiate database locally from scripts
12. Unit test each database object