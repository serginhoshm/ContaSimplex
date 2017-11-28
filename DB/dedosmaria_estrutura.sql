CREATE TABLE clientes (
    clienteid integer NOT NULL,
    clientenome character varying(255) NOT NULL,
    clienteemail character varying(255),
    deptoid integer NOT NULL,
    clientemktmail bit   DEFAULT 0,
    PRIMARY KEY (clienteid)
);

GO

CREATE TABLE clientescreditos (
    clienteid integer NOT NULL,
    clicreddataconcedido datetime NOT NULL,
    clicredvalor double precision DEFAULT 0 NOT NULL,
    clicreddatabaixa datetime,
    clicredvalorbaixado double precision,
    clicredobs character varying(255),
    PRIMARY KEY (clienteid, clicreddataconcedido)
);

GO

CREATE VIEW creditospendentes AS
 SELECT cli.clienteid,
    cli.clientenome,
    cred.clicredvalor
   FROM (clientescreditos cred
     JOIN clientes cli ON ((cred.clienteid = cli.clienteid)))
  WHERE (COALESCE(cred.clicredvalorbaixado, (0)) < COALESCE(cred.clicredvalor, (0)));

GO

CREATE TABLE departamentos (
    deptoid integer NOT NULL,
    deptodescricao character varying(255),
    PRIMARY KEY (deptoid)
);

GO

CREATE TABLE faturamentos (
    faturid integer NOT NULL,
    clienteid integer NOT NULL,
    faturdatageracao datetime NOT NULL,
    faturvalortotal numeric(18,4) DEFAULT 0 NOT NULL,
    faturvalorbaixado numeric(18,4) DEFAULT 0 NOT NULL,
    faturvalorcancelado numeric(18,4) DEFAULT 0 NOT NULL,
    faturdataenvioemail datetime,
    faturdataenvioemail2 datetime,
    faturobserv character varying(255),
    PRIMARY KEY (faturid)
);

GO

CREATE VIEW faturamentospendentes AS
 SELECT faturamentos.faturid,
    clientes.clientenome,
    clientes.clienteemail,
    faturamentos.faturdatageracao,
    faturamentos.faturvalortotal,
    faturamentos.faturvalorbaixado,
    faturamentos.faturdataenvioemail2,
    (faturamentos.faturvalortotal - (faturamentos.faturvalorbaixado + faturamentos.faturvalorcancelado)) AS valorpendente,
    faturamentos.faturvalorcancelado,
    clientes.clienteid
   FROM (clientes
     JOIN faturamentos ON ((clientes.clienteid = faturamentos.clienteid)))
  WHERE ((faturamentos.faturvalortotal - (faturamentos.faturvalorbaixado + faturamentos.faturvalorcancelado)) > (0));

GO

CREATE TABLE fornecedores (
    fornecid integer NOT NULL,
    fornecnome character varying(100),
    email character varying(255),
    fone character varying(255),
    PRIMARY KEY (fornecid)
);

GO

CREATE TABLE itenscomprados (
    itemcompid integer NOT NULL,
    fornecedorid integer NOT NULL,
    produtoid integer NOT NULL,
    itemcompdata datetime NOT NULL,
    itemcompquantidade integer NOT NULL,
    itemcompvalorunitario numeric(18,4) NOT NULL,
    itemcompvalortotal numeric(18,4) NOT NULL,
    PRIMARY KEY (itemcompid)
);

GO

CREATE TABLE itensvendidos (
    itemid integer NOT NULL,
    produtoid integer NOT NULL,
    clienteid integer NOT NULL,
    itemquantidade integer DEFAULT 1 NOT NULL,
    itemvalorunitario double precision NOT NULL,
    itemvalortotal double precision,
    datareferencia datetime NOT NULL,
    faturamentoid integer,
    PRIMARY KEY (itemid)
);

GO

CREATE TABLE produtos (
    produtoid integer NOT NULL,
    produtonome character varying(255),
    consultaem datetime,
    produtoumref integer NOT NULL,
    produtoumrefvalor double precision DEFAULT 0 NOT NULL,
    produzido bit   DEFAULT 0,
    ativo bit   DEFAULT 0,
    PRIMARY KEY (produtoid)
);

GO

CREATE TABLE produtosprecovenda (
    produtoid integer NOT NULL,
    prodprecovendata datetime NOT NULL,
    prodprecovenvalor double precision DEFAULT 0 NOT NULL,
    PRIMARY KEY (produtoid, prodprecovendata)
);

GO

CREATE TABLE recibos (
    reciboid integer NOT NULL,
    faturid integer,
    recibodatageracao datetime,
    recibovalorpago numeric(18,4),
    recibovalorcredito numeric(18,4),
    recibovalortroco numeric(18,4),
    reciboautentic character varying(10),
    recibodataenviocomprov datetime,
    PRIMARY KEY (reciboid)
);

GO

CREATE VIEW maladiretaemailrecebimentos AS
 SELECT r.reciboid,
    c.clienteid,
    c.clientenome,
    c.clienteemail,
    r.recibovalorpago,
    r.recibovalortroco,
    r.reciboautentic,
    r.recibodatageracao,
    f.faturid
   FROM ((faturamentos f
     JOIN recibos r ON ((f.faturid = r.faturid)))
     JOIN clientes c ON ((c.clienteid = f.clienteid)))
  WHERE (r.recibodataenviocomprov IS NULL);

GO

CREATE VIEW maladiretafaturpendente AS
 SELECT clientes.clientenome,
    clientes.clienteemail,
    faturamentos.faturvalortotal,
    faturamentos.faturid
   FROM (clientes
     JOIN faturamentos ON ((clientes.clienteid = faturamentos.clienteid)))
  WHERE (((faturamentos.faturvalorcancelado + faturamentos.faturvalorbaixado) < faturamentos.faturvalortotal) AND (faturamentos.faturdataenvioemail IS NULL));

GO

CREATE VIEW recebercliente_det AS
 SELECT DISTINCT departamentos.deptodescricao,
    clientes.clientenome,
    produtos.produtonome,
    itensvendidos.itemvalorunitario,
    sum(itensvendidos.itemquantidade) AS soma_itemquantidade,
    sum(itensvendidos.itemvalortotal) AS soma_itemvalortotal,
    itensvendidos.datareferencia
   FROM (produtos
     JOIN (departamentos
     JOIN (clientes
     JOIN itensvendidos ON ((clientes.clienteid = itensvendidos.clienteid))) ON ((departamentos.deptoid = clientes.deptoid))) ON ((produtos.produtoid = itensvendidos.produtoid)))
  WHERE (itensvendidos.faturamentoid IS NULL)
  GROUP BY departamentos.deptodescricao, clientes.clientenome, produtos.produtonome, itensvendidos.itemvalorunitario, itensvendidos.datareferencia;

GO

CREATE TABLE unidadesmedida (
    umcod integer NOT NULL,
    umnome character varying(255) NOT NULL,
    umsigla character varying(3) NOT NULL, 
    PRIMARY KEY (umcod)
);

GO

CREATE UNIQUE INDEX idx_um_umnome ON  unidadesmedida (umnome);

GO

CREATE UNIQUE INDEX idx_um_umsigla ON  unidadesmedida (umsigla);

GO

CREATE UNIQUE INDEX idx_cli_cliemail ON  clientes (clienteemail);

GO

CREATE UNIQUE INDEX idx_cli_clinome ON  clientes (clientenome);

GO

CREATE INDEX idx_cli_deptoid ON clientes  (deptoid);

GO

CREATE INDEX idx_fornec_fornecid ON fornecedores  (fornecid);

GO

CREATE INDEX idx_itensc_fornecid ON itenscomprados  (fornecedorid);

GO

CREATE INDEX idx_itensv_clienteid ON itensvendidos  (clienteid);

GO

CREATE INDEX idx_itensv_faturid ON itensvendidos  (faturamentoid);

GO

CREATE INDEX idx_itensv_prodid ON itensvendidos  (produtoid);

GO

CREATE INDEX idx_prod_produmref ON produtos  (produtoumref);

GO

CREATE INDEX idx_recib_faturid_idx ON recibos  (faturid);

GO

CREATE INDEX idx_recib_reciboid ON recibos  (reciboid);

GO

CREATE INDEX idx_rec_recid_fatid_idx ON recibos  (reciboid, faturid);

