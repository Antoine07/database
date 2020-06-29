-- phpMyAdmin SQL Dump
-- version 4.5.4.1deb2ubuntu2.1
-- http://www.phpmyadmin.net
--
-- Client :  localhost
-- Généré le :  Dim 09 Février 2020 à 13:49
-- Version du serveur :  5.7.29-0ubuntu0.16.04.1
-- Version de PHP :  7.1.25-1+ubuntu16.04.1+deb.sury.org+1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `db_aviation`
--

-- --------------------------------------------------------

--
-- Structure de la table `compagnies`
--

CREATE TABLE `compagnies` (
  `comp` char(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `street` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numStreet` tinyint(3) UNSIGNED DEFAULT NULL,
  `status` enum('published','unpublished','draft') COLLATE utf8mb4_unicode_ci DEFAULT 'draft'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Contenu de la table `compagnies`
--

INSERT INTO `compagnies` (`comp`, `street`, `city`, `name`, `numStreet`, `status`) VALUES
('AUS', 'sidney', 'Australie', 'AUSTRA Air', 19, 'draft'),
('CHI', 'chi', 'Chine', 'CHINA Air', NULL, 'draft'),
('FRE1', 'beaubourg', 'France', 'Air France', 17, 'draft'),
('FRE2', 'paris', 'France', 'Air Electric', 22, 'draft'),
('ITA', 'mapoli', 'Rome', 'Italia Air', 20, 'draft'),
('PILL', NULL, NULL, 'pillili', NULL, 'draft'),
('SIN', 'pasir', 'Singapour', 'SIN A', 15, 'draft');

-- --------------------------------------------------------

--
-- Structure de la table `pilots`
--

CREATE TABLE `pilots` (
  `certificate` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lead_pl` varchar(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numFlying` decimal(7,1) DEFAULT NULL,
  `compagny` char(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bonus` decimal(5,1) DEFAULT NULL,
  `num_jobs` tinyint(3) UNSIGNED DEFAULT NULL,
  `next_flight` datetime DEFAULT NULL,
  `birth_date` datetime DEFAULT NULL,
  `created` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Contenu de la table `pilots`
--

INSERT INTO `pilots` (`certificate`, `lead_pl`, `numFlying`, `compagny`, `name`, `bonus`, `num_jobs`, `next_flight`, `birth_date`, `created`) VALUES
('ct-1', 'ct-7', '90.0', 'AUS', 'Alan', '1000.0', NULL, NULL, NULL, '2020-02-09 13:40:27'),
('ct-10', 'ct-7', '90.0', 'FRE1', 'Tom', '500.0', NULL, NULL, NULL, '2020-02-09 13:40:27'),
('ct-100', 'ct-7', '200.0', 'SIN', 'Yi', '500.0', NULL, NULL, NULL, '2020-02-09 13:40:27'),
('ct-11', 'ct-6', '200.0', 'AUS', 'Sophie', '1000.0', NULL, NULL, NULL, '2020-02-09 13:40:27'),
('ct-12', 'ct-6', '190.0', 'AUS', 'Albert', '1000.0', NULL, NULL, NULL, '2020-02-09 13:40:27'),
('ct-16', 'ct-6', '190.0', 'SIN', 'Yan', '500.0', NULL, NULL, NULL, '2020-02-09 13:40:27'),
('ct-56', NULL, '300.0', 'AUS', 'Benoit', '2000.0', NULL, NULL, NULL, '2020-02-09 13:40:27'),
('ct-6', NULL, '20.0', 'FRE1', 'Jhon', '500.0', NULL, NULL, NULL, '2020-02-09 13:40:27'),
('ct-7', NULL, '80.0', 'CHI', 'Pierre', '500.0', NULL, NULL, NULL, '2020-02-09 13:40:27');

--
-- Index pour les tables exportées
--

--
-- Index pour la table `compagnies`
--
ALTER TABLE `compagnies`
  ADD PRIMARY KEY (`comp`);

--
-- Index pour la table `pilots`
--
ALTER TABLE `pilots`
  ADD PRIMARY KEY (`certificate`),
  ADD UNIQUE KEY `un_name` (`name`),
  ADD KEY `fk_pilots_compagny` (`compagny`),
  ADD KEY `lead_pl` (`lead_pl`);

--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `pilots`
--
ALTER TABLE `pilots`
  ADD CONSTRAINT `fk_pilots_compagny` FOREIGN KEY (`compagny`) REFERENCES `compagnies` (`comp`),
  ADD CONSTRAINT `pilots_ibfk_1` FOREIGN KEY (`lead_pl`) REFERENCES `pilots` (`certificate`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
