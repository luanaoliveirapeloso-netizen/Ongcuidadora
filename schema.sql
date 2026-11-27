-- OngCuidadora · schema.sql
-- Recria o banco do zero: pode ser executado várias vezes seguidas.

SET NAMES utf8mb4;
DROP DATABASE IF EXISTS ongcuidadora;
CREATE DATABASE ongcuidadora CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ongcuidadora;

-- Usuários que acessam o sistema (login)
CREATE TABLE usuario (
  id_usuario     INT AUTO_INCREMENT PRIMARY KEY,
  nome           VARCHAR(150) NOT NULL,
  email          VARCHAR(100) NOT NULL UNIQUE,
  senha_hash     VARCHAR(255) NOT NULL,
  perfil         VARCHAR(20)  NOT NULL DEFAULT 'voluntario'
                 CHECK (perfil IN ('admin', 'voluntario')),
  ativo          BOOLEAN      NOT NULL DEFAULT TRUE,
  data_cadastro  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Voluntários cuidadores
CREATE TABLE voluntario (
  id_voluntario  INT AUTO_INCREMENT PRIMARY KEY,
  nome           VARCHAR(150) NOT NULL,
  email          VARCHAR(100) UNIQUE,
  telefone       VARCHAR(20)  NOT NULL,
  ativo          BOOLEAN      NOT NULL DEFAULT TRUE,
  data_cadastro  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Pessoas atendidas pela ONG
-- LGPD: sem CPF e sem endereço completo; o bairro basta para organizar as visitas
CREATE TABLE assistido (
  id_assistido      INT AUTO_INCREMENT PRIMARY KEY,
  nome              VARCHAR(150) NOT NULL,
  data_nascimento   DATE         NOT NULL,
  telefone_contato  VARCHAR(20)  NOT NULL,
  bairro            VARCHAR(80)  NOT NULL,
  ativo             BOOLEAN      NOT NULL DEFAULT TRUE,
  data_cadastro     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tipos de cuidado oferecidos (ex.: companhia, acompanhamento a consultas)
CREATE TABLE tipo_cuidado (
  id_tipo_cuidado  INT AUTO_INCREMENT PRIMARY KEY,
  nome             VARCHAR(80)  NOT NULL UNIQUE,
  descricao        VARCHAR(255)
);

-- Atendimento: um voluntário visita um assistido em uma data
CREATE TABLE atendimento (
  id_atendimento    INT AUTO_INCREMENT PRIMARY KEY,
  id_assistido      INT          NOT NULL,
  id_voluntario     INT          NOT NULL,
  data_atendimento  DATE         NOT NULL,
  hora_inicio       TIME         NOT NULL,
  duracao_minutos   INT          NOT NULL CHECK (duracao_minutos > 0),
  status            VARCHAR(20)  NOT NULL DEFAULT 'agendado'
                    CHECK (status IN ('agendado', 'realizado', 'cancelado')),
  observacao        VARCHAR(500),
  data_cadastro     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_assistido)  REFERENCES assistido (id_assistido),
  FOREIGN KEY (id_voluntario) REFERENCES voluntario (id_voluntario)
);

-- N:N entre atendimento e tipo_cuidado
CREATE TABLE atendimento_cuidado (
  id_atendimento   INT NOT NULL,
  id_tipo_cuidado  INT NOT NULL,
  PRIMARY KEY (id_atendimento, id_tipo_cuidado),
  FOREIGN KEY (id_atendimento)  REFERENCES atendimento (id_atendimento) ON DELETE CASCADE,
  FOREIGN KEY (id_tipo_cuidado) REFERENCES tipo_cuidado (id_tipo_cuidado)
);

-- Doações em dinheiro recebidas pela ONG
CREATE TABLE doacao (
  id_doacao      INT AUTO_INCREMENT PRIMARY KEY,
  nome_doador    VARCHAR(150),
  valor          DECIMAL(10,2) NOT NULL CHECK (valor > 0),
  forma          VARCHAR(20)   NOT NULL
                 CHECK (forma IN ('pix', 'dinheiro', 'cartao', 'transferencia')),
  data_doacao    DATE          NOT NULL,
  data_cadastro  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
);
