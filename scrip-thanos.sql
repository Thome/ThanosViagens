CREATE SCHEMA thanos

CREATE DOMAIN telefone AS INT[];
CREATE DOMAIN tipo_cpf AS VARCHAR(11);


-- Table: thanos.gerente

-- DROP TABLE thanos.gerente;

CREATE TABLE thanos.gerente
(
    cpf tipo_cpf NOT NULL,
    nome_completo character varying(45) NOT NULL,
    email character varying(45) NOT NULL,
    senha character varying(45) NOT NULL,
    fone_gerente telefone NOT NULL,
    CONSTRAINT pk_gerente PRIMARY KEY (cpf),
    CONSTRAINT uq_gerente UNIQUE (email, senha, fone_gerente)
);

-- Table: thanos.endereco

-- DROP TABLE thanos.endereco;

CREATE TABLE thanos.endereco
(
    id_endereco integer NOT NULL,
    cep character varying(10) NOT NULL,
    cidade character varying(45) NOT NULL,
    estado character varying(45) NOT NULL,
    pais character varying(45) NOT NULL,
    numero integer,
    rua character varying(45) NOT NULL,
    bairro character varying(45) NOT NULL,
    complemento character varying(45),
    ponto_referencia character varying(45),
    CONSTRAINT pk_endereco PRIMARY KEY (id_endereco),
    CONSTRAINT uq_endereco UNIQUE (cep, rua, bairro, cidade, estado)
);


-- Table: thanos.hospedaria

-- DROP TABLE thanos.hospedaria;

CREATE TABLE thanos.hospedaria
(
    nome_comercial character varying(45) NOT NULL,
    cnpj character varying(14) NOT NULL,
    CONSTRAINT pk_hospedaria PRIMARY KEY (cnpj),
    CONSTRAINT uq_hospedaria UNIQUE (nome_comercial)
);


-- Table: thanos.franquia

-- DROP TABLE thanos.franquia;

CREATE TABLE thanos.franquia
(
    id_franquia integer NOT NULL,
    nome character varying(45) NOT NULL,
    wifi boolean NOT NULL,
    restaurante boolean NOT NULL,
    estacionamento boolean NOT NULL,
    piscina boolean NOT NULL,
    bar boolean NOT NULL,
    lavanderia boolean NOT NULL,
    id_endereco integer NOT NULL,
    cpf_gerente tipo_cpf NOT NULL,
    cnpj character varying(14) NOT NULL,
    CONSTRAINT pk_franquia PRIMARY KEY (id_franquia),
    CONSTRAINT fk_cnpj FOREIGN KEY (cnpj)
        REFERENCES thanos.hospedaria (cnpj) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_endereco FOREIGN KEY (id_endereco)
        REFERENCES thanos.endereco (id_endereco) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_gerente FOREIGN KEY (cpf_gerente)
        REFERENCES thanos.gerente (cpf) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Table: thanos.usuario

-- DROP TABLE thanos.usuario;

CREATE TABLE thanos.usuario
(
    cpf tipo_cpf NOT NULL,
    nome_completo character varying(45) NOT NULL,
    email character varying(45) NOT NULL,
    senha character varying(45) NOT NULL,
    fone_usuario telefone NOT NULL,
    CONSTRAINT pk_usuario PRIMARY KEY (cpf)
);

CREATE TABLE thanos.avaliacao_usuario
(
    id_avaliacao integer NOT NULL,
    servicos double precision NOT NULL,
    acomodacoes double precision NOT NULL,
    comentario character varying(200),
    cpf_usuario character varying(11) NOT NULL,
    franquia_id integer NOT NULL,
    CONSTRAINT pk_avaliacao_usuario PRIMARY KEY (id_avaliacao),
    CONSTRAINT fk_franquiaeval FOREIGN KEY (franquia_id)
        REFERENCES thanos.franquia (id_franquia) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_usuario FOREIGN KEY (cpf_usuario)
        REFERENCES thanos.usuario (cpf) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Table: thanos.tipo_de_quarto

-- DROP TABLE thanos.tipo_de_quarto;

CREATE TABLE thanos.tipo_de_quarto
(
    id_tipo integer NOT NULL,
    nome_tipo_quarto character varying(45) NOT NULL,
    compartilhado boolean NOT NULL,
    valor integer NOT NULL,
    area integer,
    CONSTRAINT pk_tipo_de_quarto PRIMARY KEY (id_tipo)
);


-- Table: thanos.tipo_de_cama

-- DROP TABLE thanos.tipo_de_cama;

CREATE TABLE thanos.tipo_de_cama
(
    id_cama integer NOT NULL,
    nome_tipo_de_cama character varying(45) NOT NULL,
    descricao character varying(45),
    CONSTRAINT pk_tipo_de_cama PRIMARY KEY (id_cama)
);


-- Table: thanos.quarto_da_hospedaria

-- DROP TABLE thanos.quarto_da_hospedaria;

CREATE TABLE thanos.quarto_da_hospedaria
(
    idfranquia integer NOT NULL,
    idtipo integer NOT NULL,
    num_serie integer NOT NULL,
    quant_quartos integer NOT NULL,
    quartos_disp integer NOT NULL,
    CONSTRAINT pk_franquia_has_tipo_de_quarto PRIMARY KEY (idfranquia, idtipo),
    CONSTRAINT fk_franquia FOREIGN KEY (idfranquia)
        REFERENCES thanos.franquia (id_franquia) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_tipo_de_quarto FOREIGN KEY (idtipo)
        REFERENCES thanos.tipo_de_quarto (id_tipo) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);


CREATE TABLE thanos.cama_esta
(
    idcama integer NOT NULL,
    idquarto integer NOT NULL,
    quant integer NOT NULL DEFAULT 1,
    CONSTRAINT pk_cama_esta PRIMARY KEY (idcama, idquarto),
    CONSTRAINT fk_tipo_cama FOREIGN KEY (idcama)
        REFERENCES thanos.tipo_de_cama (id_cama) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_tipo_quarto FOREIGN KEY (idquarto)
        REFERENCES thanos.tipo_de_quarto (id_tipo) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

-- Table: thanos.forma_de_pagamento

-- DROP TABLE thanos.forma_de_pagamento;

CREATE TABLE thanos.forma_de_pagamento
(
    id_pagamento integer NOT NULL,
    quarto character varying(45) NOT NULL,
    nome character varying(45),
    situacao character varying(45),
    CONSTRAINT pk_pagamento PRIMARY KEY (id_pagamento)
);

CREATE TABLE thanos.boleto
(
    codigo_boleto integer NOT NULL,
    pagamento_id integer NOT NULL,
    CONSTRAINT pk_boleto PRIMARY KEY (codigo_boleto),
    CONSTRAINT fk_boleto FOREIGN KEY (pagamento_id)
        REFERENCES thanos.forma_de_pagamento (id_pagamento) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Table: thanos.cartao

-- DROP TABLE thanos.cartao;

CREATE TABLE thanos.cartao
(
    numero_cartao integer NOT NULL,
    agencia character varying(45),
    pagamento_id integer NOT NULL,
    CONSTRAINT pk_cartao PRIMARY KEY (pagamento_id),
    CONSTRAINT fk_pagamento FOREIGN KEY (pagamento_id)
        REFERENCES thanos.forma_de_pagamento (id_pagamento) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


-- Table: thanos.reserva_quarto

-- DROP TABLE thanos.reserva_quarto;

CREATE TABLE thanos.reserva_quarto
(
    id_reserva_quarto integer NOT NULL,
    entrada date NOT NULL,
    saida date NOT NULL,
    valor integer NOT NULL,
    cpf character varying(11) NOT NULL,
    id_tipo_de_quarto integer NOT NULL,
    id_pagamento integer NOT NULL,
    CONSTRAINT pk_reserva_quarto PRIMARY KEY (id_reserva_quarto),
    CONSTRAINT fk_pagamento FOREIGN KEY (id_pagamento)
        REFERENCES thanos.forma_de_pagamento (id_pagamento) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_tipo_de_quarto FOREIGN KEY (id_tipo_de_quarto)
        REFERENCES thanos.tipo_de_quarto (id_tipo) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_usuario FOREIGN KEY (cpf)
        REFERENCES thanos.usuario (cpf) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT ck_valor_negativo CHECK (valor > 0)
);

set search_path to thanos;

insert into gerente
values ('10010010001','thome pereira','thomepereira@ufs','001','{99999999,11111111,99999988}'),
('10010010002','jose valmir','josevalmir@ufs','002','{66666666,11111112,99887766}'),
('10010010003','welerson welerson','welerson@ufs','003','{88888888,11111113,88776655}'),
('10010010004','matheus almeida','matheusssa@ufs','004','{98989898,11111114,77777777}'),
('10010010005','raul andrade','howl@ufs','005','{10000000,11111115,01010101}'),
('10010010006','jaine conceicao','jaine@ufs','006','{10000060,11111116,01010106}'),
('10010010007','filipe barreto','flpbrrto@ufs','007','{10000070,11111117,01010107}'),
('10010010008','tulio ihc','tulioihc@ufs','008','{10000080,11111118,01010108}'),
('10010010009','jardel itabaiana','jard@ufs','009','{10000090,11111119,01010109}'),
('10010010010','fabio fabiolo','fbo@ufs','010','{10000100,11111120,01010110}');

insert into endereco values
(1,'49032490','aracaju','sergipe','brasil',7171,'av murilo dantas','farolandia','ap 032','em frente ao farol'),
(2,'49032480','aracaju','sergipe','brasil',4800,'av orlando dantas','farolandia','','atras da unit'),
(3,'49032470','aracaju','sergipe','brasil',4700,'rua jose valmir','valmirlandia','',''),
(4,'49032460','aracaju','sergipe','brasil',4600,'rua batata','orla','',''),
(5,'94023456','recife','pernambuco','brasil',789,'av pernambuco','centro','',''),
(6,'99033440','belem','para','brasil',987,'travessa de chocolate','tenente brigadeiro','',''),
(7,'10000000','terra sem cep','acre','brasil',0,'rua dos bobos','bairro dos bobos','casa muito engracada','nao tem teto nem nada'),
(8,'10200222','canudos','bahia','brasil',22,'rua dois','segundo bairro','',''),
(9,'40400404','notfound','acre','brasil',404,'rua Nullpointerexception','bairro nulo','',''),
(10,'88800888','hong kong','RAE','china',888,'ching chang street','chinatown','','uma estatua de mao em frente'),
(11,'12345678','las vegas','nevada','estados unidos',1234,'cassino street','hosteland','',''),
(12,'12012120','miami','florida','estados unidos',12,'miami street','miami beach','miami complement','miami reference'),
(13,'21022102','madrid','madrid','espanha',21,'el rua espanhola','el bairro','',''),
(14,'15151515','paris','Ile-de-France','frança',15,'le rue français','le quartier','le complément','le référence'),
(15,'16161616','roma','lazio','itália',16,'la strada','il quartiere','',''),
(16,'17171717','atenas','attica','grécia',17,'to drómo','ti geitoniá','',''),
(17,'18181818','berlim','berlim','alemanha',18,'die Straße','die Nachbarschaft','',''),
(18,'19191919','moscou','moscow province','russia',19,'ulitsa','okrestnosti','',''),
(19,'20202020','lisboa','distrito de lisboa','portugal',20,'a rua','o bairro','',''),
(20,'21212121','cancún','quintana roo','méxico',8,'rua el chavo','vila el chavo','','em frente a muralha'),
(21,'22222222','rio de janeiro','rio de janeiro','brasil',22222,'avenida brasil','bairro america','','');

insert into hospedaria values 
('BLX','1234567800110'),
('MSTR','1234567800111'),
('Hotéis TPAN','1234567800103'),
('Valmirnio Hotéis','1234567800104'),
('Lessinho Hostels','1234567800101'),
('P&NP','1234567800102'),
('DedelTeis','1234567800105'),
('Howlteis','1234567800106'),
('BRUNL','1234567800107');

insert into franquia values
(1,'Casa do Farol',true,true,true,false,false,false,1,'10010010001','1234567800103'),
(2,'HostWel',true,false,false,false,false,false,2,'10010010003','1234567800101'),
(3,'Valmiresort',false,false,false,false,false,false,3,'10010010002','1234567800104'),
(4,'Batatorla',true,true,false,false,true,false,4,'10010010003','1234567800101'),
(5,'Valmirecife',true,false,true,false,true,false,5,'10010010002','1234567800104'),
(6,'Pousada do Doce',true,true,true,false,false,false,6,'10010010009','1234567800105'),
(7,'Hostel do Wel',false,false,false,false,false,false,7,'10010010003','1234567800101'),
(8,'Casa do Neto',true,true,true,true,true,false,8,'10010010001','1234567800103'),
(9,'Null Pointer',true,true,true,true,false,true,9,'10010010006','1234567800102'),
(10,'Neto Chinês',true,true,true,false,false,true,10,'10010010001','1234567800103'),
(11,'Los Pollos Hermanos',true,true,true,true,true,false,11,'10010010004','1234567800107'),
(12,'Mamma Miami',true,true,true,true,false,false,12,'10010010004','1234567800107'),
(13,'El Zorro',true,true,false,false,true,false,13,'10010010009','1234567800105'),
(14,'Pai Francês',true,true,true,false,false,false,14,'10010010005','1234567800106'),
(15,'Hotel Cesár',false,true,true,false,true,false,13,'10010010009','1234567800105'),
(16,'Casa do Grego',true,true,true,true,false,true,16,'10010010001','1234567800103'),
(17,'Null-Zeiger-Ausnahme',true,true,true,true,true,true,17,'10010010006','1234567800102'),
(18,'Vlaldmir Putin',true,false,true,false,true,false,18,'10010010002','1234567800104'),
(19,'O Néscio Português',true,false,false,false,false,false,19,'10010010002','1234567800104'),
(20,'Casa do Rico',true,true,true,true,true,true,20,'10010010001','1234567800103'),
(21,'Canto Itabaiano',true,true,true,false,false,false,21,'10010010009','1234567800105');

insert into usuario values
('20010010001','carros tombos','tomb@ufs','101','{20001111,20001112}'),
('20010010002','enrique schnoiado','sch@ufs','102','{20003333,20003334,20003335}'),
('20010010003','dreno pivo','piv@ufs','103','{20004444}'),
('20010010004','mano canudo','canu@ufs','104','{42424242}'),
('20010010005','endriq peixeira','hdrk@ufs','105','{20005555}'),
('20010010006','leilao trofeu','lei@ufs','106','{20006666}'),
('20010010007','dafny fernando lucero palma','dafny@ufs','107','{20007777}'),
('20010010008','quênia cordel','enia@ufs','108','{20008888}'),
('20010010009','galileu galilei','gal@ufs','109','{20009999}'),
('20010010010','rafa charada','charada@ufs','110','{20010000}'),
('20010010011','sandy junior','sandy@ufs','111','{20011111}'),
('20010010012','beatriz trinchao','andre@ufs','112','{20001111}');

insert into tipo_de_cama values
(1,'Cama Individual','90-130 cm de largura'),
(2,'Cama de Casal','131-150 cm de largura'),
(3,'Cama Larga','151-180 cm de largura'),
(4,'Cama de Casal Extra-Larga','181-210 cm de largura'),
(5,'Beliche','Tamanho variável'),
(6,'Sofá-Cama','Tamanho variável'),
(7,'Futon','Tamanho variável');


insert into avaliacao_usuario values
(1,0.0,0.0,'Lugar terrível','20010010001',19),
(2,10.0,10.0,'Magnífico','20010010006',17),
(3,10.0,10.0,'Lugar Excelente','20010010001',17),
(4,10.0,10.0,'Divino','20010010003',17),
(5,10.0,10.0,'Muito bom!','20010010009',9),
(6,10.0,10.0,'Atendimento excelente, lugar maravilhoso, restaurante muito bom!','20010010012',9),
(7,9.0,5.2,'Serviços muito bons mas acomodações precárias','20010010005',1),
(8,7.2,7.0,'Hospedagem satisfatória','20010010008',1),
(9,4.5,5.5,'Não foi muita coisa','20010010004',2),
(10,0.0,3.5,'Nenhum serviço','20010010007',3),
(11,0.0,5.5,'Serviu pra dormir','20010010002',3),
(12,8.5,7.5,'Boas batatas','20010010011',4),
(13,3.5,5.5,'Batatas ruins','20010010010',4),
(14,6.6,2.2,'Lugar ruim','20010010008',5),
(15,9.0,8.5,'Doces bons','20010010005',6),
(16,10.0,8.0,'Legal','20010010001',6),
(17,10.0,10.0,'Muito bom','20010010005',8),
(18,8.5,7.5,'Mais ou menos','20010010006',8),
(19,9,9.5,'Gostei muito mas nem tanto','20010010002',8),
(20,7.7,7.5,'Muito barulho e animal, wifi não era boa','20010010004',10),
(21,8.5,8.7,'Lugar exótico','20010010011',10),
(22,9.9,9.9,'Nada é perfeito','20010010002',11),
(23,9.5,9.4,'Bem massa','20010010012',11),
(24,9.7,9.8,'Gustavo atendeu muito bem','20010010008',11),
(25,7.5,10.0,'Bom mas faltou luz a tarde toda','20010010007',12),
(26,10.0,6.0,'Lugarzinho estranho','20010010011',12),
(27,5.2,6.4,'Zorro é folgado','20010010002',13),
(28,5.4,6.6,'Poderia ter sido melhor','20010010009',13),
(29,8,8,'Deu pro gasto','20010010008',13),
(30,8.5,9.5,'Tirando os problemas foi 100%','20010010005',14),
(31,10,8,'Quarto foi meio abafado','20010010003',14),
(32,9.0,6.0,'A cama estava dura, desconfortável, fora isso foi aceitável','20010010007',14),
(33,6.7,7.4,'A salada era antiga e os quartos feios','20010010010',15),
(34,10.0,10.0,'Gostei do grego','20010010011',16),
(35,5.0,9.0,'Quartos bons mas falhou muito no atendimento','20010010001',16),
(36,3.5,3.5,'Acomodações ruins e serviços faltaram muito','20010010012',18),
(37,4.5,4.0,'O gerente é muito otário e o atendimento foi de má qualidade','20010010011',18),
(38,10.0,10.0,'Me senti como um político cheio de regalias rsrsrs','20010010005',20),
(39,10.0,10.0,'Muito legal. Recomendo. :)','20010010012',20),
(40,6.0,7.0,'Tinha cabelo na minha comida! Horror!','20010010008',20),
(41,9.5,9.5,'Foi legal.','20010010007',20),
(42,2.5,3.0,'Me lembrou de itabaiana!','20010010009',21),
(43,4.5,4.0,'Tinha cupim rolando solto nas camas!','20010010010',21),
(44,7,7,'Foi satisfatível mas pecou na questão de ergonomia.','20010010002',21),
(45,5.2,5.6,'Lugarzinho decadente','20010010006',21);

insert into forma_de_pagamento values
(1,'Quarto 1','P1','Pendente'),
(2,'Quarto 2','P2','Pendente'),
(3,'Quarto 3','P3','Pago'),
(4,'Quarto 4','P4','Pago'),
(5,'Quarto 5','P5','Pago');

insert into cartao values
(1001,'banco do brasil',1),
(1101,'santander',2),
(1111,'caixa',3);

insert into boleto values
(1,4),
(2,5);

insert into tipo_de_quarto values
(1,'Quarto de Casal',false,150,12),
(2,'Quarto Família',false,200,15),
(3,'Quarto Single',false,130,null),
(4,'Quarto República',true,115,15);

insert into quarto_da_hospedaria values
(1,1,3,3, 4),
(1,3,2,3, 6),
(3,4,1,2, 7),
(15,1,2,5, 7),
(16,2,1,3, 10),
(16,1,2,2, 9);

insert into cama_esta values
(2,1,1),
(2,2,1),
(1,2,2),
(1,3,1),
(5,4,3); 

insert into reserva_quarto values
(1,'2018-08-31','2018-09-02',130,'20010010001',3,1),
(2,'2018-08-29','2018-08-31',115,'20010010003',4,2),
(3,'2018-08-27','2018-08-30',115,'20010010005',4,3),
(4,'2018-09-03','2018-09-06',130,'20010010006',3,4),
(5,'2018-09-02','2018-09-04',200,'20010010012',2,5);
