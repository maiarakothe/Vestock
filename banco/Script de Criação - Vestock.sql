-- Criação do Banco de Dados:

create database vestock;

----------------------------------------
-- Criação das Tabelas

CREATE TABLE Cliente (
  codcli    int4 NOT NULL, 
  cpfcli    varchar(11) NOT NULL UNIQUE, 
  datcadcli timestamp NOT NULL, 
  codloj    int4 NOT NULL, 
  CONSTRAINT pkey_cliente 
    PRIMARY KEY (codcli));
COMMENT ON TABLE Cliente IS 'Cadastros de Clientes';
COMMENT ON COLUMN Cliente.codcli IS 'Código do Cliente';
COMMENT ON COLUMN Cliente.cpfcli IS 'CPF do Cliente';
COMMENT ON COLUMN Cliente.datcadcli IS 'Data do cadastro do Cliente';

CREATE TABLE Condicional (
  codcnd       SERIAL NOT NULL, 
  nomitncon    varchar(40) NOT NULL, 
  datretitncon timestamp NOT NULL, 
  datdevitncon timestamp NOT NULL, 
  obsitncon    varchar(150), 
  devitncon    bool NOT NULL, 
  codcli       int4 NOT NULL, 
  codloj       int4 NOT NULL, 
  CONSTRAINT pkey_condicional 
    PRIMARY KEY (codcnd));
COMMENT ON TABLE Condicional IS 'Cadastros de itens levados no Condicional';
COMMENT ON COLUMN Condicional.codcnd IS 'Código do Condicional';
COMMENT ON COLUMN Condicional.nomitncon IS 'Nome dos itens levados no Condicional';
COMMENT ON COLUMN Condicional.datretitncon IS 'Data da retirada do item no condicional';
COMMENT ON COLUMN Condicional.datdevitncon IS 'Data da devolução do item no condicional';
COMMENT ON COLUMN Condicional.obsitncon IS 'Observações do condicional';
COMMENT ON COLUMN Condicional.devitncon IS 'Devolução do condicional';

CREATE TABLE Desconto (
  coddsc SERIAL NOT NULL, 
  nomdsc varchar(40) NOT NULL, 
  valdsc numeric(4, 2) NOT NULL, 
  caddsc timestamp NOT NULL, 
  vlddsc date NOT NULL, 
  codloj int4 NOT NULL, 
  CONSTRAINT pkey_desconto 
    PRIMARY KEY (coddsc));
COMMENT ON TABLE Desconto IS 'Cadastros de Descontos';
COMMENT ON COLUMN Desconto.coddsc IS 'Código do Desconto';
COMMENT ON COLUMN Desconto.nomdsc IS 'Nome do Desconto (Ex. Cupom de Páscoa)';
COMMENT ON COLUMN Desconto.valdsc IS 'Valor do Desconto em porcentagem';
COMMENT ON COLUMN Desconto.caddsc IS 'Data de inicio da validade do Desconto';
COMMENT ON COLUMN Desconto.vlddsc IS 'Validade do Desconto';

CREATE TABLE Fornecedor (
  codfor    int4 NOT NULL, 
  cnpfor    varchar(14) NOT NULL UNIQUE, 
  nomfanfor varchar(80), 
  codloj    int4 NOT NULL, 
  CONSTRAINT pkey_fornecedor 
    PRIMARY KEY (codfor));
COMMENT ON TABLE Fornecedor IS 'Cadastro de Fornecedores';
COMMENT ON COLUMN Fornecedor.codfor IS 'Código do Fornecedor';
COMMENT ON COLUMN Fornecedor.cnpfor IS 'CNPJ do Fornecedor';
COMMENT ON COLUMN Fornecedor.nomfanfor IS 'Nome Fantasia do Fornecedor';

CREATE TABLE Funcionario (
  codpes    int4 NOT NULL, 
  cpffun    varchar(11) NOT NULL UNIQUE, 
  carfun    varchar(40) NOT NULL, 
  datadmfun timestamp NOT NULL, 
  codloj    int4 NOT NULL, 
  CONSTRAINT pkey_funcionario 
    PRIMARY KEY (codpes));
COMMENT ON TABLE Funcionario IS 'Cadastros de Funcionarios';
COMMENT ON COLUMN Funcionario.codpes IS 'Código do Funcionário';
COMMENT ON COLUMN Funcionario.cpffun IS 'CPF do Funcionario';
COMMENT ON COLUMN Funcionario.carfun IS 'Cargo do Funcionario';
COMMENT ON COLUMN Funcionario.datadmfun IS 'Data de admissão do Funcionairo, ela será feita juntamente com o cadastro do mesmo';

CREATE TABLE item_condicional (
  coditecon SERIAL NOT NULL, 
  qtditecon int4 NOT NULL, 
  codcnd    int4 NOT NULL, 
  codpro    int4 NOT NULL, 
  CONSTRAINT pkey_item_condicional 
    PRIMARY KEY (coditecon));
COMMENT ON COLUMN item_condicional.coditecon IS 'Código do item no condicional';
COMMENT ON COLUMN item_condicional.qtditecon IS 'Quantidade de item no condicional';

CREATE TABLE item_venda (
  coditeven    SERIAL NOT NULL, 
  qtditeven    int4 NOT NULL, 
  vlruniteven  numeric(6, 2) NOT NULL, 
  vlrtotiteven numeric(6, 2) NOT NULL, 
  codven       int4 NOT NULL, 
  codpro       int4 NOT NULL, 
  CONSTRAINT pkey_item_venda 
    PRIMARY KEY (coditeven));
COMMENT ON TABLE item_venda IS 'Item com a venda';
COMMENT ON COLUMN item_venda.coditeven IS 'Código do item venda';
COMMENT ON COLUMN item_venda.qtditeven IS 'Quantidade de item por venda';
COMMENT ON COLUMN item_venda.vlruniteven IS 'Preço unitário na venda';
COMMENT ON COLUMN item_venda.vlrtotiteven IS 'Valor total dos itens por venda';

CREATE TABLE Loja (
  codloj   SERIAL NOT NULL, 
  nomloj   varchar(80) NOT NULL, 
  rualoj   varchar(100) NOT NULL, 
  bailoj   varchar(40) NOT NULL, 
  cidloj   varchar(40) NOT NULL, 
  telloj   varchar(20) NOT NULL, 
  cnploj   varchar(14) NOT NULL UNIQUE, 
  emaloj   varchar(80) NOT NULL UNIQUE, 
  senhaloj varchar(200) NOT NULL, 
  CONSTRAINT pkey_loja 
    PRIMARY KEY (codloj));
COMMENT ON TABLE Loja IS 'Cadastro de lojas';
COMMENT ON COLUMN Loja.codloj IS 'Código da loja';
COMMENT ON COLUMN Loja.nomloj IS 'Nome da loja';
COMMENT ON COLUMN Loja.rualoj IS 'Rua do endereço da loja';
COMMENT ON COLUMN Loja.bailoj IS 'Bairro do endereço da loja';
COMMENT ON COLUMN Loja.cidloj IS 'Cidade onde a loja está localizada';
COMMENT ON COLUMN Loja.telloj IS 'Telefone da loja';
COMMENT ON COLUMN Loja.cnploj IS 'CNPJ da loja';
COMMENT ON COLUMN Loja.emaloj IS 'email da loja';
COMMENT ON COLUMN Loja.senhaloj IS 'Senha da Loja';

CREATE TABLE Pessoa (
  codpes SERIAL NOT NULL, 
  nompes varchar(80) NOT NULL, 
  emapes varchar(80) NOT NULL UNIQUE, 
  sexpes char(1) NOT NULL CHECK(sexpes in ('M', 'F')), 
  telpes varchar(20) NOT NULL, 
  ruapes varchar(100) NOT NULL, 
  baipes varchar(20) NOT NULL, 
  cidpes varchar(50) NOT NULL, 
  estpes varchar(20) NOT NULL, 
  CONSTRAINT pkey_pessoa 
    PRIMARY KEY (codpes));
COMMENT ON TABLE Pessoa IS 'Tabelas de cadastro de Pessoas';
COMMENT ON COLUMN Pessoa.nompes IS 'Nome da Pessoa';
COMMENT ON COLUMN Pessoa.emapes IS 'Email da Pessoa';
COMMENT ON COLUMN Pessoa.sexpes IS 'Sexo da Pessoa';
COMMENT ON COLUMN Pessoa.telpes IS 'Telefone da Pessoa';
COMMENT ON COLUMN Pessoa.ruapes IS 'Rua da Pessoa';
COMMENT ON COLUMN Pessoa.baipes IS 'Bairro da Pessoa';
COMMENT ON COLUMN Pessoa.cidpes IS 'Cidade da Pessoa';
COMMENT ON COLUMN Pessoa.estpes IS 'Estado que a Pessoa mora';

CREATE TABLE Produto (
  codpro    SERIAL NOT NULL, 
  nompro    varchar(100) NOT NULL UNIQUE, 
  tampro    varchar(10) NOT NULL, 
  corpro    varchar(40) NOT NULL, 
  tipro     varchar(40) NOT NULL, 
  custpro   numeric(6, 2) NOT NULL, 
  vendpro   numeric(6, 2) NOT NULL, 
  qtdestpro int4 NOT NULL, 
  datcadpro timestamp NOT NULL, 
  despro    text, 
  atipro    bool DEFAULT 'TRUE' NOT NULL CHECK(atipro in (TRUE, FALSE)), 
  codloj    int4 NOT NULL, 
  codfor    int4 NOT NULL, 
  CONSTRAINT pkey_produto 
    PRIMARY KEY (codpro));
COMMENT ON TABLE Produto IS 'Cadastro dos produtos';
COMMENT ON COLUMN Produto.nompro IS 'Nome do produto';
COMMENT ON COLUMN Produto.tampro IS 'Tamanho do produto. P, M, G ou medidas';
COMMENT ON COLUMN Produto.corpro IS 'Cor do produto';
COMMENT ON COLUMN Produto.tipro IS 'Tipo do produto.';
COMMENT ON COLUMN Produto.custpro IS 'Preço de custo do produto';
COMMENT ON COLUMN Produto.vendpro IS 'Preço de venda do produto';
COMMENT ON COLUMN Produto.qtdestpro IS 'Quantidade em estoque do produto';
COMMENT ON COLUMN Produto.datcadpro IS 'Data do cadastro do produto';
COMMENT ON COLUMN Produto.despro IS 'Descrição do produto';
COMMENT ON COLUMN Produto.atipro IS 'TRUE: produto ativo e FALSE: produto inativo';

CREATE TABLE Venda (
  codven    SERIAL NOT NULL, 
  datven    timestamp NOT NULL, 
  totven    numeric(6, 2) NOT NULL, 
  fompagven varchar(20) NOT NULL CHECK(fompagven in ('Dinheiro', 'Credito', 'Debito', 'Pix')), 
  cupdscven numeric(5, 2), 
  codcli    int4 NOT NULL, 
  codfun    int4 NOT NULL, 
  coddsc    int4, 
  codloj    int4 NOT NULL, 
  CONSTRAINT pkey_venda 
    PRIMARY KEY (codven));
COMMENT ON TABLE Venda IS 'Cadastro de Vendas';
COMMENT ON COLUMN Venda.codven IS 'Código da Venda';
COMMENT ON COLUMN Venda.datven IS 'Data da Venda';
COMMENT ON COLUMN Venda.totven IS 'Valor total da Venda';
COMMENT ON COLUMN Venda.fompagven IS 'Forma de pagamento da Venda.
(Dinheiro, Crédito, Débito, Pix)';
COMMENT ON COLUMN Venda.cupdscven IS 'Cupom de desconto da Venda para clientes cadastrados';

ALTER TABLE Cliente ADD CONSTRAINT cliente_codloj_fkey_001 FOREIGN KEY (codloj) REFERENCES Loja (codloj);
ALTER TABLE Cliente ADD CONSTRAINT cliente_codpes_fkey_001 FOREIGN KEY (codcli) REFERENCES Pessoa (codpes);
ALTER TABLE Condicional ADD CONSTRAINT condicional_ccodcli_fkey_001 FOREIGN KEY (codcli) REFERENCES Cliente (codcli);
ALTER TABLE Condicional ADD CONSTRAINT condicional_codloj_fkey_001 FOREIGN KEY (codloj) REFERENCES Loja (codloj);
ALTER TABLE Desconto ADD CONSTRAINT desconto_codloj_fkey_001 FOREIGN KEY (codloj) REFERENCES Loja (codloj);
ALTER TABLE Fornecedor ADD CONSTRAINT fornecedor_codloj_fkey_001 FOREIGN KEY (codloj) REFERENCES Loja (codloj);
ALTER TABLE Fornecedor ADD CONSTRAINT fornecedor_codpes_fkey_001 FOREIGN KEY (codfor) REFERENCES Pessoa (codpes);
ALTER TABLE Funcionario ADD CONSTRAINT funcionario_codloj_fkey_001 FOREIGN KEY (codloj) REFERENCES Loja (codloj);
ALTER TABLE Funcionario ADD CONSTRAINT funcionario_codpes_fkey_001 FOREIGN KEY (codpes) REFERENCES Pessoa (codpes);
ALTER TABLE item_condicional ADD CONSTRAINT "item_condicional_codcnd_fkey_002
" FOREIGN KEY (codcnd) REFERENCES Condicional (codcnd);
ALTER TABLE item_condicional ADD CONSTRAINT "item_condicional_codpro_fkey_001
" FOREIGN KEY (codpro) REFERENCES Produto (codpro);
ALTER TABLE item_venda ADD CONSTRAINT item_venda_codpro_fkey_001 FOREIGN KEY (codpro) REFERENCES Produto (codpro);
ALTER TABLE item_venda ADD CONSTRAINT item_venda_codven_fkey_002 FOREIGN KEY (codven) REFERENCES Venda (codven);
ALTER TABLE Produto ADD CONSTRAINT produto_codfor_fkey_001 FOREIGN KEY (codfor) REFERENCES Fornecedor (codfor);
ALTER TABLE Produto ADD CONSTRAINT produto_coloj_fkey_002 FOREIGN KEY (codloj) REFERENCES Loja (codloj);
ALTER TABLE Venda ADD CONSTRAINT venda_codcli_fkey_002 FOREIGN KEY (codcli) REFERENCES Cliente (codcli);
ALTER TABLE Venda ADD CONSTRAINT venda_coddsc_fkey_001 FOREIGN KEY (coddsc) REFERENCES Desconto (coddsc);
ALTER TABLE Venda ADD CONSTRAINT venda_codfun_fkey_001 FOREIGN KEY (codfun) REFERENCES Funcionario (codpes);
ALTER TABLE Venda ADD CONSTRAINT venda_codloj_fkey_001 FOREIGN KEY (codloj) REFERENCES Loja (codloj);


-----------------------------------------------
-- Criação dos Índices:

create unique index idx_produto_codpro on produto (codpro);

create index idx_venda_datven on venda (datven);

create unique index idx_cliente_codcli on cliente (codcli);
create unique index idx_cliente_cpfcli on cliente (cpfcli);

create unique index idx_funcionario_codfun on funcionario (codpes);
create unique index idx_funcionario_cpffun on funcionario (cpffun);