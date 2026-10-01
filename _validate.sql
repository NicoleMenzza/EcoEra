USE tempdb
GO
IF OBJECT_ID('dbo.Favorito') IS NOT NULL DROP TABLE dbo.Favorito;
IF OBJECT_ID('dbo.Comentario') IS NOT NULL DROP TABLE dbo.Comentario;
IF OBJECT_ID('dbo.PontoExploracao') IS NOT NULL DROP TABLE dbo.PontoExploracao;
IF OBJECT_ID('dbo.Artigo') IS NOT NULL DROP TABLE dbo.Artigo;
IF OBJECT_ID('dbo.Categoria') IS NOT NULL DROP TABLE dbo.Categoria;
IF OBJECT_ID('dbo.Mensagem') IS NOT NULL DROP TABLE dbo.Mensagem;
IF OBJECT_ID('dbo.RecuperarSenha') IS NOT NULL DROP TABLE dbo.RecuperarSenha;
IF OBJECT_ID('dbo.Usuario') IS NOT NULL DROP TABLE dbo.Usuario;
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
VALUES ('Beltrana de SÃ¡', 'beltrana@ecoera.com.br', '$2a$10$Su2UIixHK/L2kAMDQAB1AusVsF6eEzwVoyU/hUBnQKtc78yGO0nzi', 'USER', NULL, GETDATE(), NULL, 'ATIVO')
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
-- TABELA: Categoria (categorias de conteÃºdo ecolÃ³gico)
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
VALUES ('Fauna', 'ConteÃºdos sobre animais e biodiversidade', GETDATE(), 'ATIVO')
INSERT Categoria (nome, descricao, dataCadastro, statusCategoria)
VALUES ('Flora', 'ConteÃºdos sobre plantas e vegetaÃ§Ã£o', GETDATE(), 'ATIVO')
INSERT Categoria (nome, descricao, dataCadastro, statusCategoria)
VALUES ('Sustentabilidade', 'PrÃ¡ticas sustentÃ¡veis e consumo consciente', GETDATE(), 'ATIVO')
INSERT Categoria (nome, descricao, dataCadastro, statusCategoria)
VALUES ('Reciclagem', 'Reaproveitamento e destinaÃ§Ã£o correta de resÃ­duos', GETDATE(), 'ATIVO')
GO

-- =========================================================
-- TABELA: Artigo (publicaÃ§Ãµes/conteÃºdos do portal)
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
VALUES ('A importÃ¢ncia das abelhas para o ecossistema', 'Entenda por que as abelhas sÃ£o essenciais para a polinizaÃ§Ã£o.', 'Texto completo sobre a importÃ¢ncia das abelhas...', NULL, 1, 1, GETDATE(), NULL, 'ATIVO')
INSERT Artigo (titulo, resumo, texto, imagem, idCategoria, idUsuario, dataPublicacao, dataAtualizacao, statusArtigo)
VALUES ('Como reduzir o consumo de plÃ¡stico em casa', 'Dicas prÃ¡ticas de sustentabilidade no dia a dia.', 'Texto completo sobre reduÃ§Ã£o de plÃ¡stico...', NULL, 3, 1, GETDATE(), NULL, 'ATIVO')
INSERT Artigo (titulo, resumo, texto, imagem, idCategoria, idUsuario, dataPublicacao, dataAtualizacao, statusArtigo)
VALUES ('Coleta seletiva: guia completo', 'Aprenda a separar corretamente o lixo reciclÃ¡vel.', 'Texto completo sobre coleta seletiva...', NULL, 4, 2, GETDATE(), NULL, 'ATIVO')
GO

-- =========================================================
-- TABELA: Comentario (comentÃ¡rios dos usuÃ¡rios nos artigos)
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
VALUES (1, 2, 'Artigo muito esclarecedor, nÃ£o sabia da importÃ¢ncia das abelhas!', GETDATE(), NULL, 'ATIVO')
INSERT Comentario (idArtigo, idUsuario, texto, dataComentario, dataAtualizacao, statusComentario)
VALUES (2, 4, 'JÃ¡ comecei a aplicar essas dicas em casa, parabÃ©ns!', GETDATE(), NULL, 'ATIVO')
GO

-- =========================================================
-- TABELA: PontoExploracao (locais/trilhas da pÃ¡gina "Explorar")
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
VALUES ('Trilha da Mata AtlÃ¢ntica', 'Percurso guiado pela reserva de mata atlÃ¢ntica local.', 'Parque Estadual - SP', 'MEDIO', NULL, 2, GETDATE(), NULL, 'ATIVO')
INSERT PontoExploracao (nome, descricao, localizacao, dificuldade, imagem, idCategoria, dataCadastro, dataAtualizacao, statusPonto)
VALUES ('Mirante das Montanhas', 'Ponto de observaÃ§Ã£o com vista para as montanhas e fauna local.', 'Serra da Mantiqueira', 'DIFICIL', NULL, 1, GETDATE(), NULL, 'ATIVO')
GO

-- =========================================================
-- TABELA: Favorito (artigos ou pontos de exploraÃ§Ã£o salvos pelo usuÃ¡rio)
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
-- CONSULTAS DE VALIDAÃ‡ÃƒO
-- =========================================================
SELECT * FROM Usuario
SELECT * FROM RecuperarSenha
SELECT * FROM Mensagem
SELECT * FROM Categoria
SELECT * FROM Artigo
SELECT * FROM Comentario
SELECT * FROM PontoExploracao
SELECT * FROM Favorito
GO
-- limpeza pós-teste
DROP TABLE dbo.Favorito;
DROP TABLE dbo.Comentario;
DROP TABLE dbo.PontoExploracao;
DROP TABLE dbo.Artigo;
DROP TABLE dbo.Categoria;
DROP TABLE dbo.Mensagem;
DROP TABLE dbo.RecuperarSenha;
DROP TABLE dbo.Usuario;
GO
