declare @gruconfid int = 0
declare @texto varchar(5000) = ''

delete from configuracoes
delete from GrupoConfiguracoes

insert into GrupoConfiguracoes (gruconfnome, configdescricao) values ('EmailProducao', 'Servidor de e-mails produção')     
insert into GrupoConfiguracoes (gruconfnome, configdescricao) values ('EmailHomolocacao', 'Servidor de e-mails homologação')     
insert into GrupoConfiguracoes (gruconfnome, configdescricao) values ('Financeiro', 'Configurações de financeiro')     

SELECT @gruconfid = gruconfid from GrupoConfiguracoes where gruconfnome = 'EmailProducao'
insert into configuracoes (gruconfid, confignome, configdescricao, configvalor) values (@gruconfid, 'EmailProducao_Servidor', 'Servidor de e-mails', 'mail.google.com.br');
insert into configuracoes (gruconfid, confignome, configdescricao, configvalor) values (@gruconfid, 'EmailProducao_Login', 'Login', 'dedosdemariabolos@gmail.com');
insert into configuracoes (gruconfid, confignome, configdescricao, configvalor) values (@gruconfid, 'EmailProducao_Nome', 'Nome', 'Bolos e Doces - Dedos de Maria');
insert into configuracoes (gruconfid, confignome, configdescricao, configvalor) values (@gruconfid, 'EmailProducao_Senha', 'Senha', '1unix()*');
insert into configuracoes (gruconfid, confignome, configdescricao, configvalor) values (@gruconfid, 'EmailProducao_Porta', 'Porta', '465');
insert into configuracoes (gruconfid, confignome, configdescricao, configvalor) values (@gruconfid, 'EmailProducao_AutenticacaoTipo', 'Tipo autenticação', '1');
insert into configuracoes (gruconfid, confignome, configdescricao, configvalor) values (@gruconfid, 'EmailProducao_AutenticacaoMetodoSSL', 'Método SSL', 'sslvTLSv1');
insert into configuracoes (gruconfid, confignome, configdescricao, configvalor) values (@gruconfid, 'EmailProducao_AutenticacaoModoSSL', 'Modo SSL', 'sslmClient');

SELECT @gruconfid = gruconfid from GrupoConfiguracoes where gruconfnome = 'EmailHomolocacao'
insert into configuracoes (gruconfid, confignome, configdescricao, configvalor) values (@gruconfid, 'EmailHomolog_Servidor', 'Servidor de e-mails', 'mail.google.com.br');
insert into configuracoes (gruconfid, confignome, configdescricao, configvalor) values (@gruconfid, 'EmailHomolog_Login', 'Login', 'serginhoshm@gmail.com');
insert into configuracoes (gruconfid, confignome, configdescricao, configvalor) values (@gruconfid, 'EmailHomolog_Nome', 'Nome', 'Bolos e Doces - Dedos de Maria');
insert into configuracoes (gruconfid, confignome, configdescricao, configvalor) values (@gruconfid, 'EmailHomolog_Senha', 'Senha', '123456');
insert into configuracoes (gruconfid, confignome, configdescricao, configvalor) values (@gruconfid, 'EmailHomolog_Porta', 'Porta', '465');
insert into configuracoes (gruconfid, confignome, configdescricao, configvalor) values (@gruconfid, 'EmailHomolog_AutenticacaoTipo', 'Tipo autenticação', '1');
insert into configuracoes (gruconfid, confignome, configdescricao, configvalor) values (@gruconfid, 'EmailHomolog_AutenticacaoMetodoSSL', 'Método SSL', 'sslvTLSv1');
insert into configuracoes (gruconfid, confignome, configdescricao, configvalor) values (@gruconfid, 'EmailHomolog_AutenticacaoModoSSL', 'Modo SSL', 'sslmClient');

SELECT @gruconfid = gruconfid from GrupoConfiguracoes where gruconfnome = 'Financeiro'
set @texto = 
'Métodos de pagamento:
 
MÉTODO 1 - CAIXINHA (auto-atendimento)
 
 - Situada no "Primeiro andar", mesmo local de venda, URNA azul
 - Deposite o valor na URNA, utilizando envelope plástico
 - Com papeleta existente no local, informe se deseja troco ou crédito.
 - No dia seguinte o troco será devolvido pessoalmente.
 - Não será devolvido TROCO no momento do pagamento.
 
MÉTODO 2 - Depósito bancário (Santander e Viacredi)
 
 
 - BANCO SANTANDER 
 - AG 4509 
 - C/C 01064448-3
 - TITULAR: SERGIO HENRIQUE MARCHIORI
 - CPF: 047.034.269-27
 
 
 - BANCO VIACREDI 
 - C/C 9337393
 - TITULAR: PAULO CESAR PEREIRA
 - CPF: 924.598.629-20
 
 
MÉTODO 3 - PicPay
 - Adicione @sergiohm e efetue seu pagamento
 - Conheça PicPay https://goo.gl/QkGxdk
 
 
MÉTODO 4 - Pessoalmente
 - SOMENTE após as 18h (não posso receber durante o expediente).
  
Em caso de alguma divergência possuo os registros para sua verificação.
 
Obrigado por consumir nossos produtos e utilize este canal de comunicação para efetuar sugestões ou críticas
 
Att. Sérgio e Paulo'
insert into configuracoes (gruconfid, confignome, configdescricao, configvalor) values (@gruconfid, 'Financeiro_TextoEmail', 'Texto principal do e-mail', @texto);

set @texto = 
'Métodos de pagamento:
 
MÉTODO 1 - CAIXINHA (auto-atendimento)
 
 - Situada no "Primeiro andar", mesmo local de venda, URNA azul
 - Deposite o valor na URNA, utilizando envelope plástico
 - Com papeleta existente no local, informe se deseja troco ou crédito.
 - No dia seguinte o troco será devolvido pessoalmente.
 - Não será devolvido TROCO no momento do pagamento.
 
MÉTODO 2 - Depósito bancário (Santander e Viacredi)
 
 
 - BANCO SANTANDER 
 - AG 4509 
 - C/C 01064448-3
 - TITULAR: SERGIO HENRIQUE MARCHIORI
 - CPF: 047.034.269-27
 
 
 - BANCO VIACREDI 
 - C/C 9337393
 - TITULAR: PAULO CESAR PEREIRA
 - CPF: 924.598.629-20
 
 
MÉTODO 3 - PicPay
 - Adicione @sergiohm e efetue seu pagamento
 - Conheça PicPay https://goo.gl/QkGxdk
 
 
MÉTODO 4 - Pessoalmente
 - SOMENTE após as 18h (não posso receber durante o expediente).
  
Em caso de alguma divergência possuo os registros para sua verificação.
 
Obrigado por consumir nossos produtos e utilize este canal de comunicação para efetuar sugestões ou críticas
 
Att. Sérgio e Paulo'

insert into configuracoes (gruconfid, confignome, configdescricao, configvalor) values (@gruconfid, 'Financeiro_TextoMeiosPagamento', 'Texto de meios de pagamento', @texto);

insert into configuracoes (gruconfid, confignome, configdescricao, configvalor) values (@gruconfid, 'Financeiro_TituloEmail', 'Título do e-mail', '');

