/* =====================================================
   DADOS DE EXEMPLO - 5 REGISTROS POR TABELA
   Compatível com PostgreSQL
   ===================================================== */

/* =========================
   LOJA
   ========================= */
INSERT INTO Loja
(codloj, nomloj, rualoj, bailoj, cidloj, telloj, cnploj, emaloj, senhaloj)
VALUES
(1, 'Loja Centro', 'Rua do Comércio, 100', 'Centro', 'Itapiranga', '4936711001', '11111111000101', 'centro@loja.com', 'senha1'),
(2, 'Loja Norte', 'Rua das Flores, 200', 'Centro', 'Chapecó', '4936711002', '11111111000102', 'norte@loja.com', 'senha2'),
(3, 'Loja Sul', 'Av. Brasil, 300', 'São Cristóvão', 'São Miguel do Oeste', '4936711003', '11111111000103', 'sul@loja.com', 'senha3'),
(4, 'Loja Oeste', 'Rua Paraná, 400', 'Industrial', 'Maravilha', '4936711004', '11111111000104', 'oeste@loja.com', 'senha4'),
(5, 'Loja Leste', 'Rua Santa Catarina, 500', 'Centro', 'Xanxerê', '4936711005', '11111111000105', 'leste@loja.com', 'senha5');

/* =========================
   PESSOA
   ========================= */
INSERT INTO Pessoa
(codpes, nompes, emapes, sexpes, telpes, ruapes, baipes, cidpes, estpes)
VALUES
(1, 'João Silva', 'joao@email.com', 'M', '49911110001', 'Rua A', 'Centro', 'Itapiranga', 'SC'),
(2, 'Maria Souza', 'maria@email.com', 'F', '49911110002', 'Rua B', 'Centro', 'Chapecó', 'SC'),
(3, 'Carlos Lima', 'carlos@email.com', 'M', '49911110003', 'Rua C', 'São Luiz', 'Maravilha', 'SC'),
(4, 'Ana Costa', 'ana@email.com', 'F', '49911110004', 'Rua D', 'Centro', 'Xanxerê', 'SC'),
(5, 'Pedro Rocha', 'pedro@email.com', 'M', '49911110005', 'Rua E', 'Industrial', 'São Miguel do Oeste', 'SC');

/* =========================
   CLIENTE
   ========================= */
INSERT INTO Cliente
(codcli, cpfcli, datcadcli, codloj)
VALUES
(1, '12345678901', '2026-01-10 10:00:00', 1),
(2, '12345678902', '2026-01-11 11:00:00', 2),
(3, '12345678903', '2026-01-12 12:00:00', 3),
(4, '12345678904', '2026-01-13 13:00:00', 4),
(5, '12345678905', '2026-01-14 14:00:00', 5);

/* =========================
   FORNECEDOR
   ========================= */
INSERT INTO Fornecedor
(codfor, cnpfor, nomfanfor, codloj)
VALUES
(1, '22222222000101', 'Têxtil Alfa', 1),
(2, '22222222000102', 'Moda Beta', 2),
(3, '22222222000103', 'Confecções Gama', 3),
(4, '22222222000104', 'Vestuário Delta', 4),
(5, '22222222000105', 'Indústria Épsilon', 5);

/* =========================
   FUNCIONARIO
   ========================= */
INSERT INTO Funcionario
(codpes, cpffun, carfun, datadmfun, codloj)
VALUES
(1, '98765432101', 'Gerente', '2025-01-05 08:00:00', 1),
(2, '98765432102', 'Vendedor', '2025-01-06 08:00:00', 2),
(3, '98765432103', 'Caixa', '2025-01-07 08:00:00', 3),
(4, '98765432104', 'Estoquista', '2025-01-08 08:00:00', 4),
(5, '98765432105', 'Vendedor', '2025-01-09 08:00:00', 5);

/* =========================
   DESCONTO
   ========================= */
INSERT INTO Desconto
(coddsc, nomdsc, valdsc, caddsc, vlddsc, codloj)
VALUES
(1, 'Cupom Verão', 10.00, '2026-01-01', '2026-12-31', 1),
(2, 'Black Friday', 20.00, '2026-01-01', '2026-11-30', 2),
(3, 'Dia das Mães', 15.00, '2026-01-01', '2026-05-31', 3),
(4, 'Natal', 25.00, '2026-01-01', '2026-12-25', 4),
(5, 'Cliente VIP', 5.00, '2026-01-01', '2026-12-31', 5);

/* =========================
   PRODUTO
   ========================= */
INSERT INTO Produto
(codpro, nompro, tampro, corpro, tipro, custpro, vendpro,
 qtdestpro, datcadpro, despro, atipro, codloj, codfor)
VALUES
(1, 'Camiseta Básica', 'M', 'Preta', 'Camiseta', 25.00, 49.90, 50,
 '2026-01-01', 'Camiseta algodão', TRUE, 1, 1),

(2, 'Calça Jeans', '42', 'Azul', 'Calça', 60.00, 119.90, 30,
 '2026-01-02', 'Calça jeans masculina', TRUE, 2, 2),

(3, 'Jaqueta Moletom', 'G', 'Cinza', 'Jaqueta', 70.00, 149.90, 20,
 '2026-01-03', 'Jaqueta com capuz', TRUE, 3, 3),

(4, 'Vestido Floral', 'P', 'Rosa', 'Vestido', 55.00, 129.90, 25,
 '2026-01-04', 'Vestido feminino', TRUE, 4, 4),

(5, 'Tênis Casual', '40', 'Branco', 'Calçado', 80.00, 199.90, 15,
 '2026-01-05', 'Tênis unissex', TRUE, 5, 5);

/* =========================
   VENDA
   ========================= */
INSERT INTO Venda
(codven, datven, totven, fompagven, cupdscven,
 codcli, codfun, coddsc, codloj)
VALUES
(1, '2026-02-01 10:00:00', 89.82, 'Pix', 10.00, 1, 1, 1, 1),
(2, '2026-02-02 11:00:00', 119.90, 'Credito', 20.00, 2, 2, 2, 2),
(3, '2026-02-03 12:00:00', 149.90, 'Debito', 15.00, 3, 3, 3, 3),
(4, '2026-02-04 13:00:00', 129.90, 'Dinheiro', 25.00, 4, 4, 4, 4),
(5, '2026-02-05 14:00:00', 199.90, 'Pix', 5.00, 5, 5, 5, 5);

/* =========================
   ITEM_VENDA
   ========================= */
INSERT INTO item_venda
(coditeven, qtditeven, vlruniteven, vlrtotiteven, codven, codpro)
VALUES
(1, 2, 49.90, 99.80, 1, 1),
(2, 1, 119.90, 119.90, 2, 2),
(3, 1, 149.90, 149.90, 3, 3),
(4, 1, 129.90, 129.90, 4, 4),
(5, 1, 199.90, 199.90, 5, 5);

/* =========================
   CONDICIONAL
   ========================= */
INSERT INTO Condicional
(codcnd, nomitncon, datretitncon, datdevitncon,
 obsitncon, devitncon, codcli, codloj)
VALUES
(1, 'Camiseta Básica', '2026-03-01', '2026-03-05',
 'Avaliação de tamanho', TRUE, 1, 1),

(2, 'Calça Jeans', '2026-03-02', '2026-03-06',
 'Cliente levou para provar', TRUE, 2, 2),

(3, 'Jaqueta Moletom', '2026-03-03', '2026-03-07',
 'Possível compra', FALSE, 3, 3),

(4, 'Vestido Floral', '2026-03-04', '2026-03-08',
 'Evento especial', TRUE, 4, 4),

(5, 'Tênis Casual', '2026-03-05', '2026-03-09',
 'Teste de conforto', FALSE, 5, 5);

/* =========================
   ITEM_CONDICIONAL
   ========================= */
INSERT INTO item_condicional
(coditecon, qtditecon, codcnd, codpro)
VALUES
(1, 1, 1, 1),
(2, 1, 2, 2),
(3, 1, 3, 3),
(4, 1, 4, 4),
(5, 1, 5, 5);