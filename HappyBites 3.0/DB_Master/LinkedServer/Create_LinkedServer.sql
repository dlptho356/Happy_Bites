
-- LINKED SERVER: Q6

EXEC sp_addlinkedserver 
    @server = 'HappyBites_Q6',
    @srvproduct = '',
    @provider = 'MSOLEDBSQL',
    @datasrc = 'YOUR_SERVER_NAME_Q6'; --select @@SERVERNAME

EXEC sp_addlinkedsrvlogin 
    @rmtsrvname = 'HappyBites_Q6',
    @useself = 'false',
    @rmtuser = 'sa',
    @rmtpassword = 'your_password';


-- LINKED SERVER: Q7

EXEC sp_addlinkedserver 
    @server = 'HappyBites_Q7',
    @srvproduct = '',
    @provider = 'MSOLEDBSQL',
    @datasrc = 'YOUR_SERVER_NAME_Q7';

EXEC sp_addlinkedsrvlogin 
    @rmtsrvname = 'HappyBites_Q7',
    @useself = 'false',
    @rmtuser = 'sa',
    @rmtpassword = 'your_password';


-- LINKED SERVER: Q8

EXEC sp_addlinkedserver 
    @server = 'HappyBites_Q8',
    @srvproduct = '',
    @provider = 'MSOLEDBSQL',
    @datasrc = 'YOUR_SERVER_NAME_Q8';

EXEC sp_addlinkedsrvlogin 
    @rmtsrvname = 'Q8_SERVER',
    @useself = 'false',
    @rmtuser = 'sa',
    @rmtpassword = 'your_password';

