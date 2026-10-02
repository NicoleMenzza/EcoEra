USE master
GO

IF EXISTS(SELECT * FROM sys.databases WHERE name='bd_ecoera')
	DROP DATABASE bd_ecoera
GO
-- CRIAR UM BANCO DE DADOS
CREATE DATABASE bd_ecoera
GO
-- ACESSAR O BANCO DE DADOS
USE bd_ecoera
GO

-- =========================================================
-- TABELA: Usuario
-- =========================================================
CREATE TABLE Usuario
(
   id			   	   INT				IDENTITY,
   nome				   VARCHAR(254)	NOT NULL,
   username			   VARCHAR(255)	NOT NULL UNIQUE,
   password			   VARCHAR(100)	NOT NULL,
   nivelAcesso		   VARCHAR(10)		    NULL, -- ADMIN ou USER
   foto				   VARBINARY(MAX)	    NULL,
   dataCadastro		SMALLDATETIME	NOT NULL DEFAULT GETDATE(),
   dataAtualizacao	SMALLDATETIME	    NULL,
   statusUsuario	   VARCHAR(20)		NOT NULL, -- ATIVO ou INATIVO ou TROCAR_SENHA

   PRIMARY KEY (id)
);
GO
-- '$2a$10$Su2UIixHK/L2kAMDQAB1AusVsF6eEzwVoyU/hUBnQKtc78yGO0nzi' = 12345678
INSERT Usuario (nome, username, password, nivelAcesso, foto, dataCadastro, dataAtualizacao, statusUsuario)
VALUES ('Fulano da Silva', 'fulano@ecoera.com.br', '$2a$10$Su2UIixHK/L2kAMDQAB1AusVsF6eEzwVoyU/hUBnQKtc78yGO0nzi', 'ADMIN', NULL, GETDATE(), NULL, 'ATIVO')
INSERT Usuario (nome, username, password, nivelAcesso, foto, dataCadastro, dataAtualizacao, statusUsuario)
VALUES ('Beltrana de Sá', 'beltrana@ecoera.com.br', '$2a$10$Su2UIixHK/L2kAMDQAB1AusVsF6eEzwVoyU/hUBnQKtc78yGO0nzi', 'USER', NULL, GETDATE(), NULL, 'ATIVO')
INSERT Usuario (nome, username, password, nivelAcesso, foto, dataCadastro, dataAtualizacao, statusUsuario)
VALUES ('Sicrana de Oliveira', 'sicrana@ecoera.com.br', '$2a$10$Su2UIixHK/L2kAMDQAB1AusVsF6eEzwVoyU/hUBnQKtc78yGO0nzi', 'USER', NULL, GETDATE(), NULL, 'INATIVO')
INSERT Usuario (nome, username, password, nivelAcesso, foto, dataCadastro, dataAtualizacao, statusUsuario)
VALUES ('Ordnael Zurc', 'ordnael@ecoera.com.br', '$2a$10$Su2UIixHK/L2kAMDQAB1AusVsF6eEzwVoyU/hUBnQKtc78yGO0nzi', 'USER', NULL, GETDATE(), NULL, 'ATIVO')
GO

-- =========================================================
-- TABELA: RecuperarSenha
-- =========================================================
CREATE TABLE RecuperarSenha
(
   id				   INT				IDENTITY,
   email			   VARCHAR(254)	NOT NULL, -- username
   codigo			CHAR(6)			NOT NULL,
   geradoEm			SMALLDATETIME	NOT NULL DEFAULT GETDATE(),
   expiraEm		   SMALLDATETIME	NOT NULL,
   statusCodigo	BIT				NOT NULL DEFAULT 1, -- 1 = ATIVO ou 0 = INATIVO

   PRIMARY KEY (id)
);
GO

-- =========================================================
-- TABELA: Mensagem (Fale Conosco)
-- =========================================================
CREATE TABLE Mensagem
(
	id	               INT			  IDENTITY,
	dataMensagem      SMALLDATETIME NOT NULL DEFAULT GETDATE(),
	emissor			   VARCHAR(100)  NOT NULL,
	email 			   VARCHAR(254)  NOT NULL,
	telefone	         VARCHAR(20)       NULL,
	texto 	         VARCHAR(400)  NOT NULL,
	dataAtualizacao   SMALLDATETIME	   NULL,
	statusMensagem    VARCHAR(10)   NOT NULL DEFAULT 'ATIVO', -- ATIVO ou INATIVO

	PRIMARY KEY (id)
);
GO
INSERT Mensagem (dataMensagem, emissor, email, telefone, texto, dataAtualizacao, statusMensagem)
VALUES (GETDATE(), 'Ordnael Zurc', 'ordnael@username.com', '(11) 98765-4123', 'Mensagem de teste', NULL, 'ATIVO')
INSERT Mensagem (dataMensagem, emissor, email, telefone, texto, dataAtualizacao, statusMensagem)
VALUES (GETDATE(), 'Maria Onete', 'maria@username.com', NULL, 'Segunda mensagem de teste', NULL, 'ATIVO')
GO

-- =========================================================
-- TABELA: Categoria (categorias de conteúdo ecológico)
-- =========================================================
CREATE TABLE Categoria
(
	id					INT				IDENTITY,
	nome				VARCHAR(100)	NOT NULL UNIQUE,
	descricao			VARCHAR(400)		NULL,
	dataCadastro		SMALLDATETIME	NOT NULL DEFAULT GETDATE(),
	statusCategoria		VARCHAR(10)		NOT NULL DEFAULT 'ATIVO', -- ATIVO ou INATIVO

	PRIMARY KEY (id)
);
GO
INSERT Categoria (nome, descricao, dataCadastro, statusCategoria)
VALUES ('Fauna', 'Conteúdos sobre animais e biodiversidade', GETDATE(), 'ATIVO')
INSERT Categoria (nome, descricao, dataCadastro, statusCategoria)
VALUES ('Flora', 'Conteúdos sobre plantas e vegetação', GETDATE(), 'ATIVO')
INSERT Categoria (nome, descricao, dataCadastro, statusCategoria)
VALUES ('Sustentabilidade', 'Práticas sustentáveis e consumo consciente', GETDATE(), 'ATIVO')
INSERT Categoria (nome, descricao, dataCadastro, statusCategoria)
VALUES ('Reciclagem', 'Reaproveitamento e destinação correta de resíduos', GETDATE(), 'ATIVO')
GO

-- =========================================================
-- TABELA: Artigo (publicações/conteúdos do portal)
-- =========================================================
CREATE TABLE Artigo
(
	id					INT				IDENTITY,
	titulo				VARCHAR(200)	NOT NULL,
	resumo				VARCHAR(400)		NULL,
	texto				VARCHAR(MAX)	NOT NULL,
	imagem				VARBINARY(MAX)		NULL,
	idCategoria			INT				NOT NULL,
	idUsuario			INT				NOT NULL, -- autor
	dataPublicacao		SMALLDATETIME	NOT NULL DEFAULT GETDATE(),
	dataAtualizacao		SMALLDATETIME		NULL,
	statusArtigo		VARCHAR(10)		NOT NULL DEFAULT 'ATIVO', -- ATIVO ou INATIVO

	PRIMARY KEY (id),
	FOREIGN KEY (idCategoria) REFERENCES Categoria(id),
	FOREIGN KEY (idUsuario) REFERENCES Usuario(id)
);
GO
INSERT Artigo (titulo, resumo, texto, imagem, idCategoria, idUsuario, dataPublicacao, dataAtualizacao, statusArtigo)
VALUES ('A importância das abelhas para o ecossistema', 'Entenda por que as abelhas são essenciais para a polinização.', 'Texto completo sobre a importância das abelhas...', NULL, 1, 1, GETDATE(), NULL, 'ATIVO')
INSERT Artigo (titulo, resumo, texto, imagem, idCategoria, idUsuario, dataPublicacao, dataAtualizacao, statusArtigo)
VALUES ('Como reduzir o consumo de plástico em casa', 'Dicas práticas de sustentabilidade no dia a dia.', 'Texto completo sobre redução de plástico...', NULL, 3, 1, GETDATE(), NULL, 'ATIVO')
INSERT Artigo (titulo, resumo, texto, imagem, idCategoria, idUsuario, dataPublicacao, dataAtualizacao, statusArtigo)
VALUES ('Coleta seletiva: guia completo', 'Aprenda a separar corretamente o lixo reciclável.', 'Texto completo sobre coleta seletiva...', NULL, 4, 2, GETDATE(), NULL, 'ATIVO')
GO

-- =========================================================
-- TABELA: Comentario (comentários dos usuários nos artigos)
-- =========================================================
CREATE TABLE Comentario
(
	id					INT				IDENTITY,
	idArtigo			INT				NOT NULL,
	idUsuario			INT				NOT NULL,
	texto				VARCHAR(400)	NOT NULL,
	dataComentario		SMALLDATETIME	NOT NULL DEFAULT GETDATE(),
	dataAtualizacao		SMALLDATETIME		NULL,
	statusComentario	VARCHAR(10)		NOT NULL DEFAULT 'ATIVO', -- ATIVO ou INATIVO

	PRIMARY KEY (id),
	FOREIGN KEY (idArtigo) REFERENCES Artigo(id),
	FOREIGN KEY (idUsuario) REFERENCES Usuario(id)
);
GO
INSERT Comentario (idArtigo, idUsuario, texto, dataComentario, dataAtualizacao, statusComentario)
VALUES (1, 2, 'Artigo muito esclarecedor, não sabia da importância das abelhas!', GETDATE(), NULL, 'ATIVO')
INSERT Comentario (idArtigo, idUsuario, texto, dataComentario, dataAtualizacao, statusComentario)
VALUES (2, 4, 'Já comecei a aplicar essas dicas em casa, parabéns!', GETDATE(), NULL, 'ATIVO')
GO

-- =========================================================
-- TABELA: PontoExploracao (locais/trilhas da página "Explorar")
-- =========================================================
CREATE TABLE PontoExploracao
(
	id					INT				IDENTITY,
	nome				VARCHAR(150)	NOT NULL,
	descricao			VARCHAR(400)		NULL,
	localizacao			VARCHAR(200)		NULL,
	dificuldade			VARCHAR(10)		    NULL, -- FACIL, MEDIO ou DIFICIL
	imagem				VARBINARY(MAX)		NULL,
	idCategoria			INT					NULL,
	dataCadastro		SMALLDATETIME	NOT NULL DEFAULT GETDATE(),
	dataAtualizacao		SMALLDATETIME		NULL,
	statusPonto			VARCHAR(10)		NOT NULL DEFAULT 'ATIVO', -- ATIVO ou INATIVO

	PRIMARY KEY (id),
	FOREIGN KEY (idCategoria) REFERENCES Categoria(id)
);
GO
INSERT PontoExploracao (nome, descricao, localizacao, dificuldade, imagem, idCategoria, dataCadastro, dataAtualizacao, statusPonto)
VALUES ('Trilha da Mata Atlântica', 'Percurso guiado pela reserva de mata atlântica local.', 'Parque Estadual - SP', 'MEDIO', NULL, 2, GETDATE(), NULL, 'ATIVO')
INSERT PontoExploracao (nome, descricao, localizacao, dificuldade, imagem, idCategoria, dataCadastro, dataAtualizacao, statusPonto)
VALUES ('Mirante das Montanhas', 'Ponto de observação com vista para as montanhas e fauna local.', 'Serra da Mantiqueira', 'DIFICIL', NULL, 1, GETDATE(), NULL, 'ATIVO')
GO

-- =========================================================
-- TABELA: Favorito (artigos ou pontos de exploração salvos pelo usuário)
-- =========================================================
CREATE TABLE Favorito
(
	id					INT				IDENTITY,
	idUsuario			INT				NOT NULL,
	idArtigo			INT					NULL,
	idPontoExploracao	INT					NULL,
	dataFavorito		SMALLDATETIME	NOT NULL DEFAULT GETDATE(),

	PRIMARY KEY (id),
	FOREIGN KEY (idUsuario) REFERENCES Usuario(id),
	FOREIGN KEY (idArtigo) REFERENCES Artigo(id),
	FOREIGN KEY (idPontoExploracao) REFERENCES PontoExploracao(id),
	CHECK ((idArtigo IS NOT NULL AND idPontoExploracao IS NULL)
	    OR (idArtigo IS NULL AND idPontoExploracao IS NOT NULL))
);
GO
INSERT Favorito (idUsuario, idArtigo, idPontoExploracao, dataFavorito)
VALUES (2, 1, NULL, GETDATE())
INSERT Favorito (idUsuario, idArtigo, idPontoExploracao, dataFavorito)
VALUES (2, NULL, 1, GETDATE())
INSERT Favorito (idUsuario, idArtigo, idPontoExploracao, dataFavorito)
VALUES (4, 2, NULL, GETDATE())
GO

-- =========================================================
-- TABELA: Anuncio (itens anunciados para troca - página "Explorar")
-- =========================================================
CREATE TABLE Anuncio
(
	id					INT				IDENTITY,
	titulo				VARCHAR(200)	NOT NULL,
	categoria			VARCHAR(100)	NOT NULL, -- categoria do item (ex.: Eletrônicos, Livros & Educação)
	condicao			VARCHAR(50)		NOT NULL, -- estado de conservação do item
	descricao			VARCHAR(1000)		NULL,
	procurandoPor		VARCHAR(500)		NULL, -- o que o anunciante aceita receber em troca
	nomeAnunciante		VARCHAR(150)	NOT NULL,
	contato				VARCHAR(150)	NOT NULL,
	idUsuario			INT					NULL, -- usuário anunciante (quando logado)
	dataAnuncio			SMALLDATETIME	NOT NULL DEFAULT GETDATE(),
	dataAtualizacao		SMALLDATETIME		NULL,
	statusAnuncio		VARCHAR(10)		NOT NULL DEFAULT 'ATIVO', -- ATIVO ou INATIVO

	PRIMARY KEY (id),
	FOREIGN KEY (idUsuario) REFERENCES Usuario(id)
);
GO
INSERT Anuncio (titulo, categoria, condicao, descricao, procurandoPor, nomeAnunciante, contato, idUsuario, dataAnuncio, dataAtualizacao, statusAnuncio)
VALUES ('Bicicleta Mountain Bike Aro 26', 'Outros', 'Usado (Bom estado)', 'Bicicleta em bom estado de conservação, precisa apenas de ajuste nos freios. Usava para ir até a escola.', 'Aceito Tablet básico, Smartphone antigo funcionando ou Livros didáticos do 3º ano.', 'Carlos Eduardo', '(11) 98765-4321', NULL, GETDATE(), NULL, 'ATIVO')
INSERT Anuncio (titulo, categoria, condicao, descricao, procurandoPor, nomeAnunciante, contato, idUsuario, dataAnuncio, dataAtualizacao, statusAnuncio)
VALUES ('Casaco de Frio Sobretudo Preto', 'Roupas & Acessórios', 'Seminovo (Ótimo estado)', 'Usado pouquíssimas vezes. Tamanho M, tecido bem quente para o inverno.', 'Troco por Mochila reforçada de costas ou Tênis tamanho 38.', 'Mariana Lima', 'mari.lima@gmail.com', NULL, GETDATE(), NULL, 'ATIVO')
GO

-- =========================================================
-- TABELA: OfertaTroca (propostas de troca enviadas para um anúncio)
-- =========================================================
CREATE TABLE OfertaTroca
(
	id					INT				IDENTITY,
	idAnuncio			INT				NOT NULL,
	itemOferecido		VARCHAR(500)	NOT NULL, -- o que o proponente oferece em troca
	nomeProponente		VARCHAR(150)	NOT NULL,
	contatoProponente	VARCHAR(150)	NOT NULL,
	idUsuario			INT					NULL, -- usuário proponente (quando logado)
	dataOferta			SMALLDATETIME	NOT NULL DEFAULT GETDATE(),
	dataAtualizacao		SMALLDATETIME		NULL,
	statusOferta		VARCHAR(10)		NOT NULL DEFAULT 'ATIVO', -- ATIVO ou INATIVO

	PRIMARY KEY (id),
	FOREIGN KEY (idAnuncio) REFERENCES Anuncio(id),
	FOREIGN KEY (idUsuario) REFERENCES Usuario(id)
);
GO
INSERT OfertaTroca (idAnuncio, itemOferecido, nomeProponente, contatoProponente, idUsuario, dataOferta, dataAtualizacao, statusOferta)
VALUES (1, 'Ofereço 1 Kit de livros de literatura escolar + Fone Bluetooth sem fio.', 'Ana Beatriz', 'ana.beatriz@email.com', NULL, GETDATE(), NULL, 'ATIVO')
GO

-- =========================================================
-- TABELA: Ecoponto (pontos de coleta/troca - página "Mapa")
-- =========================================================
CREATE TABLE Ecoponto
(
	id						INT				IDENTITY,
	nome					VARCHAR(150)	NOT NULL,
	endereco				VARCHAR(200)		NULL,
	bairro					VARCHAR(100)		NULL,
	horarioFuncionamento	VARCHAR(150)		NULL,
	posicaoX				DECIMAL(5,2)		NULL, -- posição horizontal (%) no mapa
	posicaoY				DECIMAL(5,2)		NULL, -- posição vertical (%) no mapa
	dataCadastro			SMALLDATETIME	NOT NULL DEFAULT GETDATE(),
	dataAtualizacao			SMALLDATETIME		NULL,
	statusEcoponto			VARCHAR(10)		NOT NULL DEFAULT 'ATIVO', -- ATIVO ou INATIVO

	PRIMARY KEY (id)
);
GO
INSERT Ecoponto (nome, endereco, bairro, horarioFuncionamento, posicaoX, posicaoY, dataCadastro, dataAtualizacao, statusEcoponto)
VALUES ('Ecoponto Central Vila Verde', 'Av. das Palmeiras, 450', 'Centro', 'Seg-Sáb 08:00 - 18:00', 48.00, 45.00, GETDATE(), NULL, 'ATIVO')
INSERT Ecoponto (nome, endereco, bairro, horarioFuncionamento, posicaoX, posicaoY, dataCadastro, dataAtualizacao, statusEcoponto)
VALUES ('Estação Recicla Aurora', 'Rua dos Girassóis, 120', 'Jardim Aurora', 'Seg-Sex 08:00 - 17:00', 28.00, 26.00, GETDATE(), NULL, 'ATIVO')
INSERT Ecoponto (nome, endereco, bairro, horarioFuncionamento, posicaoX, posicaoY, dataCadastro, dataAtualizacao, statusEcoponto)
VALUES ('Ponto Verde Parque', 'Alameda dos Ipês, 88', 'Parque das Nações', 'Seg-Dom 07:00 - 19:00', 74.00, 32.00, GETDATE(), NULL, 'ATIVO')
INSERT Ecoponto (nome, endereco, bairro, horarioFuncionamento, posicaoX, posicaoY, dataCadastro, dataAtualizacao, statusEcoponto)
VALUES ('Coleta Tech Flores', 'Rua da Alvorada, 305', 'Alto das Flores', 'Ter-Sáb 09:00 - 17:00', 22.00, 68.00, GETDATE(), NULL, 'ATIVO')
INSERT Ecoponto (nome, endereco, bairro, horarioFuncionamento, posicaoX, posicaoY, dataCadastro, dataAtualizacao, statusEcoponto)
VALUES ('Ecoponto Marista', 'Av. Universitária, 1020', 'Vila Marista', 'Seg-Sex 08:00 - 18:00, Sáb 08:00 - 12:00', 82.00, 72.00, GETDATE(), NULL, 'ATIVO')
INSERT Ecoponto (nome, endereco, bairro, horarioFuncionamento, posicaoX, posicaoY, dataCadastro, dataAtualizacao, statusEcoponto)
VALUES ('Reciclagem Vida Verde', 'Rua das Acácias, 54', 'Vila Verde', 'Seg-Sáb 08:00 - 17:30', 36.00, 52.00, GETDATE(), NULL, 'ATIVO')
INSERT Ecoponto (nome, endereco, bairro, horarioFuncionamento, posicaoX, posicaoY, dataCadastro, dataAtualizacao, statusEcoponto)
VALUES ('Ponto Eco Aurora Norte', 'Rua das Bromélias, 210', 'Jardim Aurora', 'Seg-Sex 09:00 - 18:00', 18.00, 18.00, GETDATE(), NULL, 'ATIVO')
INSERT Ecoponto (nome, endereco, bairro, horarioFuncionamento, posicaoX, posicaoY, dataCadastro, dataAtualizacao, statusEcoponto)
VALUES ('Ecoponto Nações Sul', 'Av. dos Estados, 990', 'Parque das Nações', 'Seg-Sáb 08:00 - 16:00', 84.00, 22.00, GETDATE(), NULL, 'ATIVO')
INSERT Ecoponto (nome, endereco, bairro, horarioFuncionamento, posicaoX, posicaoY, dataCadastro, dataAtualizacao, statusEcoponto)
VALUES ('Centro de Descarte Flores Leste', 'Rua Hortênsias, 412', 'Alto das Flores', 'Seg-Sex 08:30 - 17:30', 58.00, 78.00, GETDATE(), NULL, 'ATIVO')
GO

-- =========================================================
-- TABELA: EcopontoMaterial (materiais aceitos por cada ecoponto)
-- =========================================================
CREATE TABLE EcopontoMaterial
(
	id			INT				IDENTITY,
	idEcoponto	INT				NOT NULL,
	material	VARCHAR(50)		NOT NULL, -- Papel, Plástico, Vidro, Metal ou Eletrônicos

	PRIMARY KEY (id),
	FOREIGN KEY (idEcoponto) REFERENCES Ecoponto(id)
);
GO
INSERT EcopontoMaterial (idEcoponto, material) VALUES (1, 'Papel')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (1, 'Plástico')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (1, 'Vidro')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (1, 'Metal')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (1, 'Eletrônicos')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (2, 'Papel')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (2, 'Plástico')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (2, 'Vidro')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (3, 'Papel')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (3, 'Plástico')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (3, 'Metal')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (4, 'Eletrônicos')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (4, 'Metal')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (4, 'Plástico')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (5, 'Vidro')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (5, 'Papel')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (5, 'Plástico')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (5, 'Metal')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (6, 'Papel')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (6, 'Plástico')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (7, 'Vidro')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (7, 'Metal')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (7, 'Eletrônicos')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (8, 'Papel')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (8, 'Vidro')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (8, 'Eletrônicos')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (9, 'Plástico')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (9, 'Vidro')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (9, 'Eletrônicos')
INSERT EcopontoMaterial (idEcoponto, material) VALUES (9, 'Metal')
GO

-- =========================================================
-- CONSULTAS DE VALIDAÇÃO
-- =========================================================
SELECT * FROM Usuario
SELECT * FROM RecuperarSenha
SELECT * FROM Mensagem
SELECT * FROM Categoria
SELECT * FROM Artigo
SELECT * FROM Comentario
SELECT * FROM PontoExploracao
SELECT * FROM Favorito
SELECT * FROM Anuncio
SELECT * FROM OfertaTroca
SELECT * FROM Ecoponto
SELECT * FROM EcopontoMaterial
