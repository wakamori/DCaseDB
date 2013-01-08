-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- ホスト: localhost
-- 生成時間: 2013 年 1 月 08 日 20:35
-- サーバのバージョン: 5.5.28
-- PHP のバージョン: 5.3.10-1ubuntu3.4

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- データベース: `dcasedb`
--

-- --------------------------------------------------------

--
-- テーブルの構造 `Argument`
--

CREATE TABLE IF NOT EXISTS `Argument` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goal_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_Argument_Node1_idx` (`goal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- テーブルの構造 `Commit`
--

CREATE TABLE IF NOT EXISTS `Commit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `method` text,
  `argument` text,
  `argument_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_Commit_Argument1` (`argument_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- テーブルの構造 `Context`
--

CREATE TABLE IF NOT EXISTS `Context` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` text,
  `value` text,
  `node_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_Context_Node1_idx` (`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- テーブルの構造 `DBNode`
--

CREATE TABLE IF NOT EXISTS `DBNode` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text,
  `description` text,
  `evidence_flag` tinyint(1) DEFAULT NULL,
  `nodeType_id` int(11) NOT NULL,
  `argument_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_Node_NodeType1_idx` (`nodeType_id`),
  KEY `fk_Node_Argument1_idx` (`argument_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- テーブルの構造 `NodeLink`
--

CREATE TABLE IF NOT EXISTS `NodeLink` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_Node_id` int(11) NOT NULL,
  `child_Node_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_NodeLink_Node1_idx` (`parent_Node_id`),
  KEY `fk_NodeLink_Node2_idx` (`child_Node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- テーブルの構造 `NodeType`
--

CREATE TABLE IF NOT EXISTS `NodeType` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

--
-- テーブルのデータをダンプしています `NodeType`
--

INSERT INTO `NodeType` (`id`, `type_name`) VALUES
(1, 'Goal'),
(2, 'Strategy'),
(3, 'Context'),
(4, 'Evidence');

--
-- ダンプしたテーブルの制約
--

--
-- テーブルの制約 `Argument`
--
ALTER TABLE `Argument`
  ADD CONSTRAINT `fk_Argument_Node1` FOREIGN KEY (`Goal_id`) REFERENCES `DBNode` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- テーブルの制約 `Commit`
--
ALTER TABLE `Commit`
  ADD CONSTRAINT `fk_Commit_Argument1` FOREIGN KEY (`Argument_id`) REFERENCES `Argument` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- テーブルの制約 `Context`
--
ALTER TABLE `Context`
  ADD CONSTRAINT `fk_Context_Node1` FOREIGN KEY (`Node_id`) REFERENCES `DBNode` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- テーブルの制約 `DBNode`
--
ALTER TABLE `DBNode`
  ADD CONSTRAINT `fk_Node_Argument1` FOREIGN KEY (`Argument_id`) REFERENCES `Argument` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Node_NodeType1` FOREIGN KEY (`NodeType_id`) REFERENCES `NodeType` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- テーブルの制約 `NodeLink`
--
ALTER TABLE `NodeLink`
  ADD CONSTRAINT `fk_NodeLink_Node1` FOREIGN KEY (`parent_Node_id`) REFERENCES `DBNode` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_NodeLink_Node2` FOREIGN KEY (`child_Node_id`) REFERENCES `DBNode` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
