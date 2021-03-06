
/****** Object:  View [dbo].[ClientesCreditosPendentes]    Script Date: 07/07/2018 03:33:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER view [dbo].[ClientesCreditosPendentes] as
  select 
  cc.clienteid
  ,c.clientenome
  ,cc.CredFaturOrigem Origem 
  ,(cc.CredValorInclusao - cc.CredValorBaixado) Saldo
  from clientescreditos cc
  join clientes c on c.clienteid = cc.clienteid
	where ((cc.CredValorInclusao - cc.CredValorBaixado) > 0)
GO
/****** Object:  View [dbo].[faturamentospendentes]    Script Date: 07/07/2018 03:33:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[faturamentospendentes] AS
 SELECT f.faturid,
    c.clientenome,
    c.clienteemail,
    f.faturdatageracao,
    f.faturvalortotal,
    f.faturvalorbaixado,
    f.faturdataenvioemail2,
    f.FaturValorAPagar AS valorpendente,
	COALESCE(f.FaturValorDesconto, 0) FaturValorDesconto,
    f.faturvalorcancelado,
    c.clienteid
   FROM (clientes c
     JOIN faturamentos f ON ((c.clienteid = f.clienteid)))
  WHERE (f.FaturValorAPagar > 0) and (f.faturvalorbaixado <= 0)
  
GO
/****** Object:  View [dbo].[maladiretaemailrecebimentos]    Script Date: 07/07/2018 03:33:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[maladiretaemailrecebimentos] AS
 SELECT r.reciboid,
    c.clienteid,
    c.clientenome,
    c.clienteemail,
    r.recibovalorpago,
    r.recibovalortroco,
    r.reciboautentic,
    r.recibodatageracao,
    f.faturid,
	r.recibovalorcredito,
	f.FaturValorAPagar
   FROM ((faturamentos f
     JOIN recibos r ON ((f.faturid = r.faturid)))
     JOIN clientes c ON ((c.clienteid = f.clienteid)))
  WHERE (r.recibodataenviocomprov IS NULL);

GO
/****** Object:  View [dbo].[maladiretafaturpendente]    Script Date: 07/07/2018 03:33:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[maladiretafaturpendente] AS
 SELECT clientes.clientenome,
    clientes.clienteemail,
    faturamentos.faturvalortotal,
    faturamentos.faturid
   FROM (clientes
     JOIN faturamentos ON ((clientes.clienteid = faturamentos.clienteid)))
  WHERE (((faturamentos.faturvalorcancelado + faturamentos.faturvalorbaixado) < faturamentos.faturvalortotal) AND (faturamentos.faturdataenvioemail IS NULL));

GO
/****** Object:  View [dbo].[recebercliente_det]    Script Date: 07/07/2018 03:33:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[recebercliente_det] AS
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
