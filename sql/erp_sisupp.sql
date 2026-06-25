-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 21-11-2025 a las 22:58:44
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `erp_g`
--

DELIMITER $$
--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `escape_json` (`val` TEXT) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    IF val IS NULL THEN
        RETURN '';
    END IF;

    RETURN REPLACE(val, '"', '\\\"');
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `acontecimiento_reportes`
--

CREATE TABLE `acontecimiento_reportes` (
  `acontecimiento_id` char(36) NOT NULL,
  `tipo` enum('vacunacion','decesos','revision','cuarentena','tratamiento','brote','limpieza') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `fecha` date NOT NULL DEFAULT current_timestamp(),
  `observacion` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `animales_involucrados` int(11) DEFAULT NULL,
  `areas_intervenidas` int(11) DEFAULT NULL,
  `estado` enum('ABIERTO','CERRADO','','') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'ABIERTO',
  `foto` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `acontecimiento_reportes`
--

INSERT INTO `acontecimiento_reportes` (`acontecimiento_id`, `tipo`, `fecha`, `observacion`, `animales_involucrados`, `areas_intervenidas`, `estado`, `foto`, `created_at`, `created_by`) VALUES
('03005bde-bcbf-4807-91c2-c567254c94ee', 'decesos', '2025-11-20', 'asdasd', 1, NULL, 'ABIERTO', 'F-2-87309c4c-6fd0-4ce4-8ba1-ad89413a55ab', '2025-11-20 17:26:32', 'd7518474-2d2f-4634-823f-71936565c110'),
('153ae8ab-cc72-47da-94bf-34c6ae6588fa', 'brote', '2025-11-15', 'qweqe', 3, NULL, 'CERRADO', 'F-1-31c2e022-606b-4421-812f-f3fc1ed2b9e4', '2025-11-14 22:55:07', 'd7518474-2d2f-4634-823f-71936565c110'),
('1d23151c-2c4a-49d9-b4a0-ab2f905d117d', 'vacunacion', '2025-11-20', 'asdasd', 2, NULL, 'CERRADO', 'F-0-28893a89-4a75-4988-a08b-a7aa11ed5450', '2025-11-20 18:11:48', 'd7518474-2d2f-4634-823f-71936565c110'),
('1d5378a4-a5bb-41f3-8182-cff07001f2bc', 'limpieza', '2025-11-15', 'qweqennj', NULL, 2, 'ABIERTO', 'F-1-8d5825d5-2e4e-436e-9d31-1a05b6ae4d97', '2025-11-14 22:55:35', 'd7518474-2d2f-4634-823f-71936565c110'),
('426d526f-8473-41c7-b2db-40967e2277f3', 'vacunacion', '2025-11-20', 'asdasasdasd', 2, NULL, 'CERRADO', 'F-0-6cdb7879-d6f1-43c2-895d-6e64441b5c4f', '2025-11-20 17:48:33', 'd7518474-2d2f-4634-823f-71936565c110'),
('4c6009f1-0064-4501-af9e-af53771e2658', 'revision', '2025-11-20', 'asdasd', 1, NULL, 'CERRADO', 'F-0-faa74901-0f5b-49fd-80a4-0fd6e3b622d2', '2025-11-20 17:45:13', 'd7518474-2d2f-4634-823f-71936565c110'),
('7bca7bb7-641e-4732-bbb6-3001821ea974', 'cuarentena', '2025-11-15', 'qweqe', 3, NULL, 'ABIERTO', 'F-1-3b09445b-f257-4fe4-bf76-53fa1f7d51b9', '2025-11-14 22:51:56', 'd7518474-2d2f-4634-823f-71936565c110'),
('98eb703b-61b5-4bd2-9e9e-a22e954a7965', 'vacunacion', '2025-11-20', 'asdas', 1, NULL, 'ABIERTO', 'F-5-47428d30-471d-4843-9034-98326bef37a9', '2025-11-20 17:46:06', 'd7518474-2d2f-4634-823f-71936565c110'),
('a031d62e-079c-4aed-ae34-d9ff7c7ce2a9', 'tratamiento', '2025-11-15', 'qweqe', 3, NULL, 'CERRADO', 'F-1-f2844268-211f-496c-bb27-628491199d9c', '2025-11-14 22:54:42', 'd7518474-2d2f-4634-823f-71936565c110'),
('a3822837-6777-444a-8e49-78e526824f72', 'decesos', '2025-11-15', '', 3, NULL, 'ABIERTO', 'F-1-8e0f8a25-f9bb-467c-b70b-fbbe4a29cd6e', '2025-11-14 23:09:19', 'd7518474-2d2f-4634-823f-71936565c110'),
('a90c886f-e702-481e-9a48-e639117956c9', 'revision', '2025-11-15', 'qweqe', 3, NULL, 'ABIERTO', 'F-1-18f87eaa-22ee-4f83-878c-41409d45ba55', '2025-11-14 22:51:34', 'd7518474-2d2f-4634-823f-71936565c110'),
('abcf532a-1682-4819-800f-cee0d9bea7c9', 'decesos', '2025-11-15', 'qweqe', 3, NULL, 'ABIERTO', 'F-1-4b4c75ef-b402-44da-bcad-d2092c102c3e', '2025-11-14 22:50:45', 'd7518474-2d2f-4634-823f-71936565c110'),
('ba02ee43-604d-4207-80fc-bb9d0e76a3ef', 'limpieza', '2025-11-15', 'qweqe', NULL, 2, 'ABIERTO', 'F-1-53368ce9-7960-46a3-b197-400ce3944e38', '2025-11-14 22:49:20', 'd7518474-2d2f-4634-823f-71936565c110'),
('f78b68a0-3045-4cca-9f64-207b8672f19c', 'vacunacion', '2025-11-20', 'asdasd', 1, NULL, 'CERRADO', 'F-3-c0c04736-37b8-41bd-bdb9-87168b90a551', '2025-11-20 17:36:20', 'd7518474-2d2f-4634-823f-71936565c110');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alertas`
--

CREATE TABLE `alertas` (
  `alerta_id` char(36) NOT NULL,
  `tipo_alerta` enum('REVISION_20_21','PROX_PARTO_117','REINCIDENCIA_APLASTAMIENTO','PESO_FUERA_RANGO','COMPATIBILIDAD_RIESGO') NOT NULL,
  `periodo_id` char(36) DEFAULT NULL,
  `animal_id` char(36) DEFAULT NULL,
  `referencia_id` char(36) DEFAULT NULL,
  `origen_modulo` enum('REPRODUCCION','PESO','TRANSFERENCIA','INCIDENCIAS') DEFAULT NULL,
  `fecha_objetivo` date NOT NULL,
  `estado_alerta` enum('PENDIENTE','ENVIADA','ATENDIDA','CANCELADA') NOT NULL DEFAULT 'PENDIENTE',
  `detalle` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` char(36) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `alertas`
--

INSERT INTO `alertas` (`alerta_id`, `tipo_alerta`, `periodo_id`, `animal_id`, `referencia_id`, `origen_modulo`, `fecha_objetivo`, `estado_alerta`, `detalle`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('5426d55a-ce1f-4ef1-868f-2b22daae078e', 'REVISION_20_21', '4e7cb250-c176-4ad0-b13e-af0544df7d89', 's90d1b25-1f83-4e74-a730-fb94fca8f9a5', NULL, NULL, '2025-11-22', 'PENDIENTE', 'Revisión 20/21 programada para la hembra CRU-001 el 2025-11-22.', '2025-11-17 10:47:22', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('e67864be-4a6f-4f05-a6c8-ad29e207a555', 'PROX_PARTO_117', '4e7cb250-c176-4ad0-b13e-af0544df7d89', 's90d1b25-1f83-4e74-a730-fb94fca8f9a5', NULL, NULL, '2026-02-26', 'PENDIENTE', 'Parto estimado a +117 días de la primera monta', NULL, NULL, NULL, NULL, NULL, NULL),
('ef81868b-071e-4762-9d67-feb4c4ed0077', 'PROX_PARTO_117', '7b222c37-bc28-43be-921a-d1c9539c45ab', 'l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', NULL, NULL, '2026-03-06', 'PENDIENTE', 'Parto estimado a +117 días de la primera monta', NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `animales`
--

CREATE TABLE `animales` (
  `animal_id` char(36) NOT NULL,
  `identificador` varchar(100) NOT NULL,
  `sexo` enum('MACHO','HEMBRA') NOT NULL,
  `especie` enum('BOVINO','OVINO','CAPRINO','PORCINO','OTRO') NOT NULL,
  `raza_id` char(36) DEFAULT NULL,
  `color` varchar(80) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
  `estado_causa` enum('deceso','venta','matanza') DEFAULT NULL,
  `etapa_productiva` enum('TERNERO','LEVANTE','CEBA','REPRODUCTOR','LACTANTE','SECA','GESTANTE','OTRO') DEFAULT NULL,
  `categoria` enum('CRIA','MADRE','PADRE','ENGORDE','REEMPLAZO','OTRO') DEFAULT NULL,
  `origen` enum('NACIMIENTO','COMPRA','TRASLADO','OTRO') NOT NULL DEFAULT 'OTRO',
  `madre_id` char(36) DEFAULT NULL,
  `padre_id` char(36) DEFAULT NULL,
  `camada_id` char(36) DEFAULT NULL,
  `fotografia_url` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `created_by` char(36) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `animales`
--

INSERT INTO `animales` (`animal_id`, `identificador`, `sexo`, `especie`, `raza_id`, `color`, `fecha_nacimiento`, `estado`, `estado_causa`, `etapa_productiva`, `categoria`, `origen`, `madre_id`, `padre_id`, `camada_id`, `fotografia_url`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('a1f3c781-24c4-4dc7-8a09-5d1d82b5b101', 'MON-001', 'MACHO', 'PORCINO', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Rosado', '2025-10-02', 'ACTIVO', NULL, 'REPRODUCTOR', '', 'COMPRA', NULL, NULL, NULL, '/uploads/mon-001.png', '2025-10-17 22:45:42', 'SYSTEM', '2025-11-12 11:13:28', 'a1f3c781-24c4-4dc7-8a09-5d1d82b5b101', NULL, NULL),
('ab29db65-86d8-46c6-bc47-85a988176e4a', 'CR500-0', 'MACHO', 'PORCINO', NULL, NULL, '2023-02-17', 'ACTIVO', NULL, NULL, NULL, 'COMPRA', NULL, NULL, NULL, '/uploads/ab29db65-86d8-46c6-bc47-85a988176e4a.webp', '2025-10-22 13:06:46', 'd7518474-2d2f-4634-823f-71936565c110', '2025-10-22 13:06:46', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL),
('b2a45ee3-9b48-4d12-9023-f86b2116a4e9', 'MON-002', 'HEMBRA', 'PORCINO', NULL, 'Rosado con manchas', '2020-05-01', 'ACTIVO', NULL, '', 'MADRE', 'COMPRA', NULL, NULL, NULL, '/uploads/mon-002.png', '2025-10-17 22:45:42', 'SYSTEM', '2025-10-17 22:45:42', 'SYSTEM', NULL, NULL),
('c39a8e24-4d60-44ef-8c52-c5ccaf861a9a', 'MON-003', 'HEMBRA', 'PORCINO', NULL, 'Rosado', '2021-06-14', 'ACTIVO', NULL, '', '', 'NACIMIENTO', 'b2a45ee3-9b48-4d12-9023-f86b2116a4e9', NULL, NULL, '/uploads/mon-003.png', '2025-10-17 22:45:42', 'SYSTEM', '2025-10-17 22:45:42', 'SYSTEM', NULL, NULL),
('d4c09b91-b94c-4e1c-bc0c-8c44486a4900', 'MON-004', 'MACHO', 'PORCINO', NULL, 'Blanco', '2021-06-14', 'ACTIVO', NULL, 'CEBA', 'ENGORDE', 'NACIMIENTO', 'b2a45ee3-9b48-4d12-9023-f86b2116a4e9', NULL, NULL, '/uploads/mon-004.png', '2025-10-17 22:45:42', 'SYSTEM', '2025-10-17 22:45:42', 'SYSTEM', NULL, NULL),
('e53de101-24d1-4b4d-b4de-37921eeb9e3a', 'MON-005', 'HEMBRA', 'PORCINO', NULL, 'Rosado', '2022-09-09', 'ACTIVO', NULL, '', '', 'NACIMIENTO', 'c39a8e24-4d60-44ef-8c52-c5ccaf861a9a', 'd4c09b91-b94c-4e1c-bc0c-8c44486a4900', NULL, '/uploads/mon-005.png', '2025-10-17 22:45:42', 'SYSTEM', '2025-10-17 22:45:42', 'SYSTEM', NULL, NULL),
('f68a74c7-98b3-4f56-9e1c-0571b803e4e1', 'MON-006', 'MACHO', 'PORCINO', NULL, 'Rosado', '2022-09-09', 'ACTIVO', NULL, 'CEBA', 'ENGORDE', 'NACIMIENTO', 'c39a8e24-4d60-44ef-8c52-c5ccaf861a9a', 'd4c09b91-b94c-4e1c-bc0c-8c44486a4900', NULL, '/uploads/mon-006.png', '2025-10-17 22:45:42', 'SYSTEM', '2025-10-17 22:45:42', 'SYSTEM', NULL, NULL),
('g79b9ac3-f2d7-466b-b65f-0fef2e367a56', 'MON-007', 'HEMBRA', 'PORCINO', NULL, 'Rosado claro', '2023-08-12', 'ACTIVO', NULL, '', '', 'NACIMIENTO', 'e53de101-24d1-4b4d-b4de-37921eeb9e3a', 'f68a74c7-98b3-4f56-9e1c-0571b803e4e1', NULL, '/uploads/mon-007.png', '2025-10-17 22:45:42', 'SYSTEM', '2025-10-17 22:45:42', 'SYSTEM', NULL, NULL),
('h8f3c8cb-61c0-466b-9481-fb032b8d14a9', 'MON-008', 'MACHO', 'PORCINO', NULL, 'Blanco', '2023-08-12', 'ACTIVO', NULL, 'CEBA', 'ENGORDE', 'NACIMIENTO', 'e53de101-24d1-4b4d-b4de-37921eeb9e3a', 'f68a74c7-98b3-4f56-9e1c-0571b803e4e1', NULL, '/uploads/mon-008.png', '2025-10-17 22:45:42', 'SYSTEM', '2025-10-17 22:45:42', 'SYSTEM', NULL, NULL),
('i90f7b5a-b8ab-4e1e-970d-702d1bcf73f2', 'MON-009', 'HEMBRA', 'PORCINO', NULL, 'Rosado con manchas', '2024-01-20', 'ACTIVO', NULL, '', '', 'NACIMIENTO', 'c39a8e24-4d60-44ef-8c52-c5ccaf861a9a', 'd4c09b91-b94c-4e1c-bc0c-8c44486a4900', NULL, '/uploads/mon-009.png', '2025-10-17 22:45:42', 'SYSTEM', '2025-10-17 22:45:42', 'SYSTEM', NULL, NULL),
('j01ae43e-324d-4d90-93f9-01f5316d1a44', 'MON-010', 'MACHO', 'PORCINO', NULL, 'Rosado', '2024-01-20', 'ACTIVO', NULL, 'CEBA', 'ENGORDE', 'NACIMIENTO', 'c39a8e24-4d60-44ef-8c52-c5ccaf861a9a', 'd4c09b91-b94c-4e1c-bc0c-8c44486a4900', NULL, '/uploads/mon-010.png', '2025-10-17 22:45:42', 'SYSTEM', '2025-10-17 22:45:42', 'SYSTEM', NULL, NULL),
('k12c3441-b7f6-4af3-8a9e-43df2b28aee7', 'SER-001', 'MACHO', 'PORCINO', NULL, 'Rosado', '2020-02-05', 'ACTIVO', NULL, 'REPRODUCTOR', '', 'COMPRA', NULL, NULL, NULL, '/uploads/ser-001.png', '2025-10-17 22:45:53', 'SYSTEM', '2025-10-17 22:45:53', 'SYSTEM', NULL, NULL),
('l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', 'SER-002', 'HEMBRA', 'PORCINO', '33333333-3333-3333-3333-333333333333', 'Blanco', '2020-04-15', 'INACTIVO', 'deceso', '', 'MADRE', 'COMPRA', 's90d1b25-1f83-4e74-a730-fb94fca8f9a5', 'k12c3441-b7f6-4af3-8a9e-43df2b28aee7', NULL, '/uploads/l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0.png', '2025-10-17 22:45:53', 'SYSTEM', '2025-11-12 11:33:53', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL),
('m34ef0bb-3a45-4cb8-9a51-c5ab91874aab', 'SER-003', 'HEMBRA', 'PORCINO', NULL, 'Rosado', '2021-07-20', 'ACTIVO', NULL, '', '', 'NACIMIENTO', 'l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', 'k12c3441-b7f6-4af3-8a9e-43df2b28aee7', NULL, '/uploads/ser-003.png', '2025-10-17 22:45:53', 'SYSTEM', '2025-10-17 22:45:53', 'SYSTEM', NULL, NULL),
('n45f1492-64f1-4f67-b81a-3e4bafcfb2f1', 'SER-004', 'MACHO', 'PORCINO', NULL, 'Rosado', '2021-07-20', 'ACTIVO', NULL, 'CEBA', 'ENGORDE', 'NACIMIENTO', 'l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', 'k12c3441-b7f6-4af3-8a9e-43df2b28aee7', NULL, '/uploads/ser-004.png', '2025-10-17 22:45:53', 'SYSTEM', '2025-10-17 22:45:53', 'SYSTEM', NULL, NULL),
('o56c983a-5cf7-4e0b-970a-5fa81dfcb778', 'SER-005', 'HEMBRA', 'PORCINO', NULL, 'Blanco', '2022-08-18', 'ACTIVO', NULL, '', '', 'NACIMIENTO', 'm34ef0bb-3a45-4cb8-9a51-c5ab91874aab', 'n45f1492-64f1-4f67-b81a-3e4bafcfb2f1', NULL, '/uploads/ser-005.png', '2025-10-17 22:45:53', 'SYSTEM', '2025-10-17 22:45:53', 'SYSTEM', NULL, NULL),
('p67a65e3-513b-4ce4-bca0-0012e6b9b23d', 'SER-006', 'MACHO', 'PORCINO', NULL, 'Rosado', '2022-08-18', 'ACTIVO', NULL, 'CEBA', 'ENGORDE', 'NACIMIENTO', 'm34ef0bb-3a45-4cb8-9a51-c5ab91874aab', 'n45f1492-64f1-4f67-b81a-3e4bafcfb2f1', NULL, '/uploads/ser-006.png', '2025-10-17 22:45:53', 'SYSTEM', '2025-10-17 22:45:53', 'SYSTEM', NULL, NULL),
('q78de9b3-4e55-4eae-933c-50cc6fba1d13', 'SER-007', 'HEMBRA', 'PORCINO', NULL, 'Rosado', '2023-06-25', 'ACTIVO', NULL, '', '', 'NACIMIENTO', 'o56c983a-5cf7-4e0b-970a-5fa81dfcb778', 'p67a65e3-513b-4ce4-bca0-0012e6b9b23d', NULL, '/uploads/ser-007.png', '2025-10-17 22:45:53', 'SYSTEM', '2025-10-17 22:45:53', 'SYSTEM', NULL, NULL),
('r89b4e6a-b25d-4fcd-952e-f3b36cb2786f', 'SER-008', 'MACHO', 'PORCINO', NULL, 'Blanco', '2023-06-25', 'ACTIVO', NULL, 'CEBA', 'ENGORDE', 'NACIMIENTO', 'o56c983a-5cf7-4e0b-970a-5fa81dfcb778', 'p67a65e3-513b-4ce4-bca0-0012e6b9b23d', NULL, '/uploads/ser-008.png', '2025-10-17 22:45:53', 'SYSTEM', '2025-10-17 22:45:53', 'SYSTEM', NULL, NULL),
('s90d1b25-1f83-4e74-a730-fb94fca8f9a5', 'CRU-001', 'HEMBRA', 'PORCINO', NULL, 'Rosado claro', '2024-09-14', 'ACTIVO', NULL, '', '', 'NACIMIENTO', 'g79b9ac3-f2d7-466b-b65f-0fef2e367a56', 'n45f1492-64f1-4f67-b81a-3e4bafcfb2f1', NULL, '/uploads/cru-001.png', '2025-10-17 22:46:09', 'SYSTEM', '2025-10-17 22:46:09', 'SYSTEM', NULL, NULL);

--
-- Disparadores `animales`
--
DELIMITER $$
CREATE TRIGGER `trg_animales_delete` BEFORE DELETE ON `animales` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'animales', OLD.animal_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'animal_id', OLD.animal_id,
      'identificador', OLD.identificador,
      'sexo', OLD.sexo,
      'especie', OLD.especie,
      'raza_id', OLD.raza_id,
      'color', OLD.color,
      'fecha_nacimiento', OLD.fecha_nacimiento,
      'estado', OLD.estado,
      'etapa_productiva', OLD.etapa_productiva,
      'categoria', OLD.categoria,
      'origen', OLD.origen,
      'madre_id', OLD.madre_id,
      'padre_id', OLD.padre_id,
      'camada_id', OLD.camada_id,
      'fotografia_url', OLD.fotografia_url,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_animales_delete_logical` AFTER UPDATE ON `animales` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'animales', OLD.animal_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'animal_id', OLD.animal_id,
        'identificador', OLD.identificador,
        'sexo', OLD.sexo,
        'especie', OLD.especie,
        'raza_id', OLD.raza_id,
        'color', OLD.color,
        'fecha_nacimiento', OLD.fecha_nacimiento,
        'estado', OLD.estado,
        'etapa_productiva', OLD.etapa_productiva,
        'categoria', OLD.categoria,
        'origen', OLD.origen,
        'madre_id', OLD.madre_id,
        'padre_id', OLD.padre_id,
        'camada_id', OLD.camada_id,
        'fotografia_url', OLD.fotografia_url,
        'created_at', OLD.created_at,
        'created_by', OLD.created_by,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_animales_insert` AFTER INSERT ON `animales` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'animales', NEW.animal_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'animal_id', NEW.animal_id,
      'identificador', NEW.identificador,
      'sexo', NEW.sexo,
      'especie', NEW.especie,
      'raza_id', NEW.raza_id,
      'color', NEW.color,
      'fecha_nacimiento', NEW.fecha_nacimiento,
      'estado', NEW.estado,
      'etapa_productiva', NEW.etapa_productiva,
      'categoria', NEW.categoria,
      'origen', NEW.origen,
      'madre_id', NEW.madre_id,
      'padre_id', NEW.padre_id,
      'camada_id', NEW.camada_id,
      'fotografia_url', NEW.fotografia_url,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_animales_update` AFTER UPDATE ON `animales` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.identificador <> NEW.identificador THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"identificador":{"old":"', escape_json(OLD.identificador), '","new":"', escape_json(NEW.identificador), '"}');
  END IF;
  IF OLD.sexo <> NEW.sexo THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"sexo":{"old":"', escape_json(OLD.sexo), '","new":"', escape_json(NEW.sexo), '"}');
  END IF;
  IF OLD.especie <> NEW.especie THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"especie":{"old":"', escape_json(OLD.especie), '","new":"', escape_json(NEW.especie), '"}');
  END IF;
  IF OLD.raza_id <> NEW.raza_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"raza_id":{"old":"', escape_json(OLD.raza_id), '","new":"', escape_json(NEW.raza_id), '"}');
  END IF;
  IF OLD.color <> NEW.color THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"color":{"old":"', escape_json(OLD.color), '","new":"', escape_json(NEW.color), '"}');
  END IF;
  IF OLD.fecha_nacimiento <> NEW.fecha_nacimiento THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"fecha_nacimiento":{"old":"', escape_json(OLD.fecha_nacimiento), '","new":"', escape_json(NEW.fecha_nacimiento), '"}');
  END IF;
  IF OLD.estado <> NEW.estado THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"estado":{"old":"', escape_json(OLD.estado), '","new":"', escape_json(NEW.estado), '"}');
  END IF;
  IF OLD.etapa_productiva <> NEW.etapa_productiva THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"etapa_productiva":{"old":"', escape_json(OLD.etapa_productiva), '","new":"', escape_json(NEW.etapa_productiva), '"}');
  END IF;
  IF OLD.categoria <> NEW.categoria THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"categoria":{"old":"', escape_json(OLD.categoria), '","new":"', escape_json(NEW.categoria), '"}');
  END IF;
  IF OLD.origen <> NEW.origen THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"origen":{"old":"', escape_json(OLD.origen), '","new":"', escape_json(NEW.origen), '"}');
  END IF;
  IF OLD.madre_id <> NEW.madre_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"madre_id":{"old":"', escape_json(OLD.madre_id), '","new":"', escape_json(NEW.madre_id), '"}');
  END IF;
  IF OLD.padre_id <> NEW.padre_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"padre_id":{"old":"', escape_json(OLD.padre_id), '","new":"', escape_json(NEW.padre_id), '"}');
  END IF;
  IF OLD.camada_id <> NEW.camada_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"camada_id":{"old":"', escape_json(OLD.camada_id), '","new":"', escape_json(NEW.camada_id), '"}');
  END IF;
  IF OLD.fotografia_url <> NEW.fotografia_url THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"fotografia_url":{"old":"', escape_json(OLD.fotografia_url), '","new":"', escape_json(NEW.fotografia_url), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'animales', OLD.animal_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `animal_decesos`
--

CREATE TABLE `animal_decesos` (
  `deceso_id` char(36) NOT NULL,
  `animal_id` char(36) NOT NULL,
  `causa_probable` varchar(255) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `observacion` varchar(255) DEFAULT NULL,
  `foto` varchar(100) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `animal_decesos`
--

INSERT INTO `animal_decesos` (`deceso_id`, `animal_id`, `causa_probable`, `fecha`, `observacion`, `foto`, `created_at`, `created_by`) VALUES
('a44dcd9f-69bc-44f5-b72e-c257eb35c26b', 'l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', 'asdasd', '2025-11-20', 'asdasd', NULL, '2025-11-20 17:26:32', 'd7518474-2d2f-4634-823f-71936565c110');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `animal_movimientos`
--

CREATE TABLE `animal_movimientos` (
  `animal_movimiento_id` char(36) NOT NULL,
  `animal_id` char(36) NOT NULL,
  `fecha_mov` date NOT NULL,
  `tipo_movimiento` enum('INGRESO','EGRESO','TRASLADO','VENTA','COMPRA','NACIMIENTO','MUERTE','OTRO') NOT NULL,
  `motivo` enum('TRASLADO','INGRESO','EGRESO','AISLAMIENTO','VENTA','OTRO') NOT NULL DEFAULT 'OTRO',
  `estado` enum('REGISTRADO','ANULADO') NOT NULL DEFAULT 'REGISTRADO',
  `finca_origen_id` char(36) DEFAULT NULL,
  `aprisco_origen_id` char(36) DEFAULT NULL,
  `area_origen_id` char(36) DEFAULT NULL,
  `recinto_id_origen` char(36) DEFAULT NULL,
  `finca_destino_id` char(36) DEFAULT NULL,
  `aprisco_destino_id` char(36) DEFAULT NULL,
  `area_destino_id` char(36) DEFAULT NULL,
  `recinto_id_destino` char(36) DEFAULT NULL,
  `costo` decimal(10,2) DEFAULT NULL,
  `documento_ref` varchar(100) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `created_by` char(36) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `animal_movimientos`
--

INSERT INTO `animal_movimientos` (`animal_movimiento_id`, `animal_id`, `fecha_mov`, `tipo_movimiento`, `motivo`, `estado`, `finca_origen_id`, `aprisco_origen_id`, `area_origen_id`, `recinto_id_origen`, `finca_destino_id`, `aprisco_destino_id`, `area_destino_id`, `recinto_id_destino`, `costo`, `documento_ref`, `observaciones`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('8fd9c4d8-020e-47dc-a0a8-95164481f6ad', 'l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', '2025-11-09', 'TRASLADO', 'TRASLADO', 'REGISTRADO', '06fcbfc8-ffc7-4956-b99d-77d879d772b7', '78059699-0f15-419e-89a8-fcc2697c4c97', '9927c9e7-d35a-4b1c-93b0-c078894cc9ef', '66de25f3-a5a7-4616-8148-7ce4513e4f04', '06fcbfc8-ffc7-4956-b99d-77d879d772b7', '78059699-0f15-419e-89a8-fcc2697c4c97', '9927c9e7-d35a-4b1c-93b0-c078894cc9ef', '66de25f3-a5a7-4616-8148-7ce4513e4f04', NULL, NULL, 'Traslado por parto a maternidad.', '2025-11-09 10:56:33', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL);

--
-- Disparadores `animal_movimientos`
--
DELIMITER $$
CREATE TRIGGER `trg_animal_movimientos_delete` BEFORE DELETE ON `animal_movimientos` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'animal_movimientos', OLD.animal_movimiento_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'animal_movimiento_id', OLD.animal_movimiento_id,
      'animal_id', OLD.animal_id,
      'fecha_mov', OLD.fecha_mov,
      'tipo_movimiento', OLD.tipo_movimiento,
      'motivo', OLD.motivo,
      'estado', OLD.estado,
      'finca_origen_id', OLD.finca_origen_id,
      'aprisco_origen_id', OLD.aprisco_origen_id,
      'area_origen_id', OLD.area_origen_id,
      'recinto_id_origen', OLD.recinto_id_origen,
      'finca_destino_id', OLD.finca_destino_id,
      'aprisco_destino_id', OLD.aprisco_destino_id,
      'area_destino_id', OLD.area_destino_id,
      'recinto_id_destino', OLD.recinto_id_destino,
      'costo', OLD.costo,
      'documento_ref', OLD.documento_ref,
      'observaciones', OLD.observaciones,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_animal_movimientos_delete_logical` AFTER UPDATE ON `animal_movimientos` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'animal_movimientos', OLD.animal_movimiento_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'animal_movimiento_id', OLD.animal_movimiento_id,
        'animal_id', OLD.animal_id,
        'fecha_mov', OLD.fecha_mov,
        'tipo_movimiento', OLD.tipo_movimiento,
        'motivo', OLD.motivo,
        'estado', OLD.estado,
        'finca_origen_id', OLD.finca_origen_id,
        'aprisco_origen_id', OLD.aprisco_origen_id,
        'area_origen_id', OLD.area_origen_id,
        'recinto_id_origen', OLD.recinto_id_origen,
        'finca_destino_id', OLD.finca_destino_id,
        'aprisco_destino_id', OLD.aprisco_destino_id,
        'area_destino_id', OLD.area_destino_id,
        'recinto_id_destino', OLD.recinto_id_destino,
        'costo', OLD.costo,
        'documento_ref', OLD.documento_ref,
        'observaciones', OLD.observaciones,
        'created_at', OLD.created_at,
        'created_by', OLD.created_by,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_animal_movimientos_insert` AFTER INSERT ON `animal_movimientos` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'animal_movimientos', NEW.animal_movimiento_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'animal_movimiento_id', NEW.animal_movimiento_id,
      'animal_id', NEW.animal_id,
      'fecha_mov', NEW.fecha_mov,
      'tipo_movimiento', NEW.tipo_movimiento,
      'motivo', NEW.motivo,
      'estado', NEW.estado,
      'finca_origen_id', NEW.finca_origen_id,
      'aprisco_origen_id', NEW.aprisco_origen_id,
      'area_origen_id', NEW.area_origen_id,
      'recinto_id_origen', NEW.recinto_id_origen,
      'finca_destino_id', NEW.finca_destino_id,
      'aprisco_destino_id', NEW.aprisco_destino_id,
      'area_destino_id', NEW.area_destino_id,
      'recinto_id_destino', NEW.recinto_id_destino,
      'costo', NEW.costo,
      'documento_ref', NEW.documento_ref,
      'observaciones', NEW.observaciones,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_animal_movimientos_update` AFTER UPDATE ON `animal_movimientos` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.animal_id <> NEW.animal_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"animal_id":{"old":"', escape_json(OLD.animal_id), '","new":"', escape_json(NEW.animal_id), '"}');
  END IF;
  IF OLD.fecha_mov <> NEW.fecha_mov THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"fecha_mov":{"old":"', escape_json(OLD.fecha_mov), '","new":"', escape_json(NEW.fecha_mov), '"}');
  END IF;
  IF OLD.tipo_movimiento <> NEW.tipo_movimiento THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"tipo_movimiento":{"old":"', escape_json(OLD.tipo_movimiento), '","new":"', escape_json(NEW.tipo_movimiento), '"}');
  END IF;
  IF OLD.motivo <> NEW.motivo THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"motivo":{"old":"', escape_json(OLD.motivo), '","new":"', escape_json(NEW.motivo), '"}');
  END IF;
  IF OLD.estado <> NEW.estado THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"estado":{"old":"', escape_json(OLD.estado), '","new":"', escape_json(NEW.estado), '"}');
  END IF;
  IF OLD.finca_origen_id <> NEW.finca_origen_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"finca_origen_id":{"old":"', escape_json(OLD.finca_origen_id), '","new":"', escape_json(NEW.finca_origen_id), '"}');
  END IF;
  IF OLD.aprisco_origen_id <> NEW.aprisco_origen_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"aprisco_origen_id":{"old":"', escape_json(OLD.aprisco_origen_id), '","new":"', escape_json(NEW.aprisco_origen_id), '"}');
  END IF;
  IF OLD.area_origen_id <> NEW.area_origen_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"area_origen_id":{"old":"', escape_json(OLD.area_origen_id), '","new":"', escape_json(NEW.area_origen_id), '"}');
  END IF;
  IF OLD.recinto_id_origen <> NEW.recinto_id_origen THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"recinto_id_origen":{"old":"', escape_json(OLD.recinto_id_origen), '","new":"', escape_json(NEW.recinto_id_origen), '"}');
  END IF;
  IF OLD.finca_destino_id <> NEW.finca_destino_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"finca_destino_id":{"old":"', escape_json(OLD.finca_destino_id), '","new":"', escape_json(NEW.finca_destino_id), '"}');
  END IF;
  IF OLD.aprisco_destino_id <> NEW.aprisco_destino_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"aprisco_destino_id":{"old":"', escape_json(OLD.aprisco_destino_id), '","new":"', escape_json(NEW.aprisco_destino_id), '"}');
  END IF;
  IF OLD.area_destino_id <> NEW.area_destino_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"area_destino_id":{"old":"', escape_json(OLD.area_destino_id), '","new":"', escape_json(NEW.area_destino_id), '"}');
  END IF;
  IF OLD.recinto_id_destino <> NEW.recinto_id_destino THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"recinto_id_destino":{"old":"', escape_json(OLD.recinto_id_destino), '","new":"', escape_json(NEW.recinto_id_destino), '"}');
  END IF;
  IF OLD.costo <> NEW.costo THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"costo":{"old":"', escape_json(OLD.costo), '","new":"', escape_json(NEW.costo), '"}');
  END IF;
  IF OLD.documento_ref <> NEW.documento_ref THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"documento_ref":{"old":"', escape_json(OLD.documento_ref), '","new":"', escape_json(NEW.documento_ref), '"}');
  END IF;
  IF OLD.observaciones <> NEW.observaciones THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"observaciones":{"old":"', escape_json(OLD.observaciones), '","new":"', escape_json(NEW.observaciones), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'animal_movimientos', OLD.animal_movimiento_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `animal_pesos`
--

CREATE TABLE `animal_pesos` (
  `animal_peso_id` char(36) NOT NULL,
  `animal_id` char(36) NOT NULL,
  `fecha_peso` date NOT NULL,
  `peso_kg` decimal(10,3) NOT NULL,
  `metodo` varchar(50) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `created_by` char(36) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `animal_pesos`
--

INSERT INTO `animal_pesos` (`animal_peso_id`, `animal_id`, `fecha_peso`, `peso_kg`, `metodo`, `observaciones`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('03c6676b-5788-4d92-9220-e8480acee8de', 'k12c3441-b7f6-4af3-8a9e-43df2b28aee7', '2025-11-17', 30.000, 'Balanza', 'fsafa', '2025-11-17 10:45:29', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('632ffb84-d3e1-4367-a2b2-abd522982bbb', 'ab29db65-86d8-46c6-bc47-85a988176e4a', '2025-11-17', 20.000, 'Balanza', 'fsafa', '2025-11-17 10:44:44', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('6508707d-c913-46dd-92b6-587c0c7c5394', 's90d1b25-1f83-4e74-a730-fb94fca8f9a5', '2025-11-17', 25.000, 'Balanza', 'fsafa', '2025-11-17 10:45:14', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('f815cc9f-3a11-430d-9c8d-9676c7e1332a', 'm34ef0bb-3a45-4cb8-9a51-c5ab91874aab', '2025-11-17', 20.000, 'Balanza', 'fsasfa', '2025-11-17 10:46:03', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL);

--
-- Disparadores `animal_pesos`
--
DELIMITER $$
CREATE TRIGGER `trg_animal_pesos_delete` BEFORE DELETE ON `animal_pesos` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'animal_pesos', OLD.animal_peso_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'animal_peso_id', OLD.animal_peso_id,
      'animal_id', OLD.animal_id,
      'fecha_peso', OLD.fecha_peso,
      'peso_kg', OLD.peso_kg,
      'metodo', OLD.metodo,
      'observaciones', OLD.observaciones,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_animal_pesos_delete_logical` AFTER UPDATE ON `animal_pesos` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'animal_pesos', OLD.animal_peso_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'animal_peso_id', OLD.animal_peso_id,
        'animal_id', OLD.animal_id,
        'fecha_peso', OLD.fecha_peso,
        'peso_kg', OLD.peso_kg,
        'metodo', OLD.metodo,
        'observaciones', OLD.observaciones,
        'created_at', OLD.created_at,
        'created_by', OLD.created_by,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_animal_pesos_insert` AFTER INSERT ON `animal_pesos` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'animal_pesos', NEW.animal_peso_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'animal_peso_id', NEW.animal_peso_id,
      'animal_id', NEW.animal_id,
      'fecha_peso', NEW.fecha_peso,
      'peso_kg', NEW.peso_kg,
      'metodo', NEW.metodo,
      'observaciones', NEW.observaciones,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_animal_pesos_update` AFTER UPDATE ON `animal_pesos` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.animal_id <> NEW.animal_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"animal_id":{"old":"', escape_json(OLD.animal_id), '","new":"', escape_json(NEW.animal_id), '"}');
  END IF;
  IF OLD.fecha_peso <> NEW.fecha_peso THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"fecha_peso":{"old":"', escape_json(OLD.fecha_peso), '","new":"', escape_json(NEW.fecha_peso), '"}');
  END IF;
  IF OLD.peso_kg <> NEW.peso_kg THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"peso_kg":{"old":"', escape_json(OLD.peso_kg), '","new":"', escape_json(NEW.peso_kg), '"}');
  END IF;
  IF OLD.metodo <> NEW.metodo THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"metodo":{"old":"', escape_json(OLD.metodo), '","new":"', escape_json(NEW.metodo), '"}');
  END IF;
  IF OLD.observaciones <> NEW.observaciones THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"observaciones":{"old":"', escape_json(OLD.observaciones), '","new":"', escape_json(NEW.observaciones), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'animal_pesos', OLD.animal_peso_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `animal_salud`
--

CREATE TABLE `animal_salud` (
  `animal_salud_id` char(36) NOT NULL,
  `animal_id` char(36) NOT NULL,
  `incidencia_id` char(36) DEFAULT NULL,
  `acontecimiento_id` char(36) DEFAULT NULL,
  `fecha_evento` date NOT NULL,
  `tipo_evento` enum('ENFERMEDAD','VACUNACION','DESPARASITACION','REVISION','TRATAMIENTO','RIÑA','AGRESIVIDAD','APLASTAMIENTO','RECHAZO_CRIAS','FUGA','OTRA') NOT NULL DEFAULT 'OTRA',
  `veterinario` varchar(100) DEFAULT NULL,
  `diagnostico` varchar(255) DEFAULT NULL,
  `severidad` enum('LEVE','MODERADA','GRAVE','NO_APLICA') DEFAULT NULL,
  `tratamiento` text DEFAULT NULL,
  `medicamento` varchar(255) DEFAULT NULL,
  `dosis` varchar(50) DEFAULT NULL,
  `via_administracion` varchar(50) DEFAULT NULL,
  `costo` decimal(10,2) DEFAULT NULL,
  `estado` enum('ABIERTO','SEGUIMIENTO','CERRADO') NOT NULL DEFAULT 'ABIERTO',
  `proxima_revision` date DEFAULT NULL,
  `responsable` varchar(100) DEFAULT NULL,
  `foto` varchar(100) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by` char(36) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `animal_salud`
--

INSERT INTO `animal_salud` (`animal_salud_id`, `animal_id`, `incidencia_id`, `acontecimiento_id`, `fecha_evento`, `tipo_evento`, `veterinario`, `diagnostico`, `severidad`, `tratamiento`, `medicamento`, `dosis`, `via_administracion`, `costo`, `estado`, `proxima_revision`, `responsable`, `foto`, `observaciones`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('01bb2978-f188-4a5e-bea4-93b34cd3f021', 'l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', NULL, NULL, '2025-11-13', 'VACUNACION', NULL, NULL, NULL, NULL, 'asd', '1', NULL, NULL, 'ABIERTO', NULL, NULL, NULL, 'asdasd', '2025-11-20 18:11:48', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('0303ed46-c8b3-4f44-85d2-c100b116801e', 'l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', NULL, NULL, '2025-11-14', '', NULL, 'Gripe porcina', NULL, NULL, NULL, NULL, NULL, NULL, 'ABIERTO', '2025-11-14', NULL, NULL, 'No se que poner aqui', '2025-11-14 11:18:35', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('14c2d153-e5d5-46e6-bf33-d3990d24cda0', 'ab29db65-86d8-46c6-bc47-85a988176e4a', NULL, NULL, '2025-11-14', 'VACUNACION', NULL, NULL, NULL, NULL, 'fsa', '2', NULL, NULL, 'ABIERTO', NULL, NULL, 'F-0-311dbaba-028b-4b22-aff9-47975b94eb94', 'fafafa', '2025-11-14 11:21:19', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('27a61a15-6e0b-4681-9739-863017f6b436', 'k12c3441-b7f6-4af3-8a9e-43df2b28aee7', NULL, NULL, '2025-11-14', 'REVISION', 'asd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ABIERTO', NULL, NULL, NULL, 'asdasd', '2025-11-20 17:45:13', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('368b6f4b-e66a-4b6c-abf3-41e35a95bd4e', 'l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', NULL, NULL, '2025-11-14', 'VACUNACION', NULL, NULL, NULL, NULL, 'fsa', '2', NULL, NULL, 'ABIERTO', NULL, NULL, 'F-1-90cdf542-5639-4609-baae-eec237a9cc3b', 'fsafafa', '2025-11-14 11:26:12', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('3a6a9f62-ff1a-45cd-ad98-a42b8ae9fc67', 'b2a45ee3-9b48-4d12-9023-f86b2116a4e9', NULL, NULL, '2025-11-14', 'VACUNACION', NULL, NULL, NULL, NULL, 'fsa', '2', NULL, NULL, 'ABIERTO', NULL, NULL, 'F-0-311dbaba-028b-4b22-aff9-47975b94eb94', 'fafafa', '2025-11-14 11:21:19', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('416f6a7c-7d31-4772-bcd4-239a50fbcf24', 'k12c3441-b7f6-4af3-8a9e-43df2b28aee7', NULL, NULL, '2025-11-13', 'VACUNACION', NULL, NULL, NULL, NULL, 'asd', '2', NULL, NULL, 'ABIERTO', NULL, NULL, NULL, 'asdas', '2025-11-20 17:46:06', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('56f0f5e9-a2ac-47cc-acec-993e53278fc3', 'o56c983a-5cf7-4e0b-970a-5fa81dfcb778', NULL, NULL, '2025-11-14', 'VACUNACION', NULL, NULL, NULL, NULL, 'fsa', '2', NULL, NULL, 'ABIERTO', NULL, NULL, 'F-0-311dbaba-028b-4b22-aff9-47975b94eb94', 'fafafa', '2025-11-14 11:21:19', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('66be63cd-8467-4f35-b244-53108d3349f7', 'l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', NULL, NULL, '2025-11-14', '', NULL, 'Gripe porcina', NULL, NULL, NULL, NULL, NULL, NULL, 'ABIERTO', '2025-11-16', NULL, NULL, 'fsafa', '2025-11-14 11:30:08', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('80a8d098-9fc2-4376-8b63-5802310cd23b', 's90d1b25-1f83-4e74-a730-fb94fca8f9a5', NULL, NULL, '2025-11-14', 'VACUNACION', NULL, NULL, NULL, NULL, 'fsa', '2', NULL, NULL, 'ABIERTO', NULL, NULL, 'F-0-311dbaba-028b-4b22-aff9-47975b94eb94', 'fafafa', '2025-11-14 11:21:19', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('9796333b-09f0-4e48-92fd-1f64c29f2832', 'm34ef0bb-3a45-4cb8-9a51-c5ab91874aab', NULL, NULL, '2025-11-06', 'VACUNACION', NULL, NULL, NULL, NULL, 'asdasd', 'asda', NULL, NULL, 'ABIERTO', NULL, NULL, NULL, 'asdasasdasd', '2025-11-20 17:48:33', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('a36deb04-c562-4d9b-926e-dc3134551f3b', 'l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', NULL, NULL, '2025-11-14', 'VACUNACION', NULL, NULL, NULL, NULL, 'fsa', '2', NULL, NULL, 'ABIERTO', NULL, NULL, 'F-1-1159ee92-331f-499a-b6a8-0230cfd068a7', 'fsafafa', '2025-11-14 11:27:23', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('ac5e03e6-02d5-49e5-a88a-fe98a4c1b069', 'r89b4e6a-b25d-4fcd-952e-f3b36cb2786f', NULL, NULL, '2025-11-14', 'VACUNACION', NULL, NULL, NULL, NULL, 'fsa', '2', NULL, NULL, 'ABIERTO', NULL, NULL, 'F-0-311dbaba-028b-4b22-aff9-47975b94eb94', 'fafafa', '2025-11-14 11:21:19', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('b3740988-766e-44a0-9c87-d01fcad7a375', 'l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', NULL, NULL, '2025-11-20', 'VACUNACION', NULL, NULL, NULL, NULL, 'asd', '1', NULL, NULL, 'ABIERTO', NULL, NULL, NULL, 'asdasd', '2025-11-20 17:36:20', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('cb5ad581-af1e-4b0e-ae28-c913bc54c1dd', 'n45f1492-64f1-4f67-b81a-3e4bafcfb2f1', NULL, NULL, '2025-11-06', 'VACUNACION', NULL, NULL, NULL, NULL, 'asdasd', 'asda', NULL, NULL, 'ABIERTO', NULL, NULL, NULL, 'asdasasdasd', '2025-11-20 17:48:33', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('e3a5b30b-1a9a-4dcd-8965-88e3e06bf673', 'm34ef0bb-3a45-4cb8-9a51-c5ab91874aab', NULL, NULL, '2025-11-13', 'VACUNACION', NULL, NULL, NULL, NULL, 'asd', '1', NULL, NULL, 'ABIERTO', NULL, NULL, NULL, 'asdasd', '2025-11-20 18:11:48', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('f09b0f02-7ed2-4ff2-b3b3-3bd1da1cec6d', 'l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', NULL, NULL, '2025-11-14', '', NULL, 'Gripe porcina', NULL, NULL, NULL, NULL, NULL, NULL, 'ABIERTO', '2025-11-16', NULL, NULL, 'fsafa', '2025-11-14 11:31:37', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('f29e0fb3-1f7c-4a08-8946-fe6778f1c3b0', 'm34ef0bb-3a45-4cb8-9a51-c5ab91874aab', NULL, NULL, '2025-11-14', 'VACUNACION', NULL, NULL, NULL, NULL, 'fsa', '2', NULL, NULL, 'ABIERTO', NULL, NULL, 'F-0-311dbaba-028b-4b22-aff9-47975b94eb94', 'fafafa', '2025-11-14 11:21:19', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL);

--
-- Disparadores `animal_salud`
--
DELIMITER $$
CREATE TRIGGER `trg_animal_salud_delete` BEFORE DELETE ON `animal_salud` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'animal_salud', OLD.animal_salud_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'animal_salud_id', OLD.animal_salud_id,
      'animal_id', OLD.animal_id,
      'fecha_evento', OLD.fecha_evento,
      'tipo_evento', OLD.tipo_evento,
      'diagnostico', OLD.diagnostico,
      'severidad', OLD.severidad,
      'tratamiento', OLD.tratamiento,
      'medicamento', OLD.medicamento,
      'dosis', OLD.dosis,
      'via_administracion', OLD.via_administracion,
      'costo', OLD.costo,
      'estado', OLD.estado,
      'proxima_revision', OLD.proxima_revision,
      'responsable', OLD.responsable,
      'observaciones', OLD.observaciones,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_animal_salud_delete_logical` AFTER UPDATE ON `animal_salud` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'animal_salud', OLD.animal_salud_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'animal_salud_id', OLD.animal_salud_id,
        'animal_id', OLD.animal_id,
        'fecha_evento', OLD.fecha_evento,
        'tipo_evento', OLD.tipo_evento,
        'diagnostico', OLD.diagnostico,
        'severidad', OLD.severidad,
        'tratamiento', OLD.tratamiento,
        'medicamento', OLD.medicamento,
        'dosis', OLD.dosis,
        'via_administracion', OLD.via_administracion,
        'costo', OLD.costo,
        'estado', OLD.estado,
        'proxima_revision', OLD.proxima_revision,
        'responsable', OLD.responsable,
        'observaciones', OLD.observaciones,
        'created_at', OLD.created_at,
        'created_by', OLD.created_by,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_animal_salud_insert` AFTER INSERT ON `animal_salud` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'animal_salud', NEW.animal_salud_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'animal_salud_id', NEW.animal_salud_id,
      'animal_id', NEW.animal_id,
      'fecha_evento', NEW.fecha_evento,
      'tipo_evento', NEW.tipo_evento,
      'diagnostico', NEW.diagnostico,
      'severidad', NEW.severidad,
      'tratamiento', NEW.tratamiento,
      'medicamento', NEW.medicamento,
      'dosis', NEW.dosis,
      'via_administracion', NEW.via_administracion,
      'costo', NEW.costo,
      'estado', NEW.estado,
      'proxima_revision', NEW.proxima_revision,
      'responsable', NEW.responsable,
      'observaciones', NEW.observaciones,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_animal_salud_update` AFTER UPDATE ON `animal_salud` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.animal_id <> NEW.animal_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"animal_id":{"old":"', escape_json(OLD.animal_id), '","new":"', escape_json(NEW.animal_id), '"}');
  END IF;
  IF OLD.fecha_evento <> NEW.fecha_evento THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"fecha_evento":{"old":"', escape_json(OLD.fecha_evento), '","new":"', escape_json(NEW.fecha_evento), '"}');
  END IF;
  IF OLD.tipo_evento <> NEW.tipo_evento THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"tipo_evento":{"old":"', escape_json(OLD.tipo_evento), '","new":"', escape_json(NEW.tipo_evento), '"}');
  END IF;
  IF OLD.diagnostico <> NEW.diagnostico THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"diagnostico":{"old":"', escape_json(OLD.diagnostico), '","new":"', escape_json(NEW.diagnostico), '"}');
  END IF;
  IF OLD.severidad <> NEW.severidad THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"severidad":{"old":"', escape_json(OLD.severidad), '","new":"', escape_json(NEW.severidad), '"}');
  END IF;
  IF OLD.tratamiento <> NEW.tratamiento THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"tratamiento":{"old":"', escape_json(OLD.tratamiento), '","new":"', escape_json(NEW.tratamiento), '"}');
  END IF;
  IF OLD.medicamento <> NEW.medicamento THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"medicamento":{"old":"', escape_json(OLD.medicamento), '","new":"', escape_json(NEW.medicamento), '"}');
  END IF;
  IF OLD.dosis <> NEW.dosis THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"dosis":{"old":"', escape_json(OLD.dosis), '","new":"', escape_json(NEW.dosis), '"}');
  END IF;
  IF OLD.via_administracion <> NEW.via_administracion THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"via_administracion":{"old":"', escape_json(OLD.via_administracion), '","new":"', escape_json(NEW.via_administracion), '"}');
  END IF;
  IF OLD.costo <> NEW.costo THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"costo":{"old":"', escape_json(OLD.costo), '","new":"', escape_json(NEW.costo), '"}');
  END IF;
  IF OLD.estado <> NEW.estado THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"estado":{"old":"', escape_json(OLD.estado), '","new":"', escape_json(NEW.estado), '"}');
  END IF;
  IF OLD.proxima_revision <> NEW.proxima_revision THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"proxima_revision":{"old":"', escape_json(OLD.proxima_revision), '","new":"', escape_json(NEW.proxima_revision), '"}');
  END IF;
  IF OLD.responsable <> NEW.responsable THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"responsable":{"old":"', escape_json(OLD.responsable), '","new":"', escape_json(NEW.responsable), '"}');
  END IF;
  IF OLD.observaciones <> NEW.observaciones THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"observaciones":{"old":"', escape_json(OLD.observaciones), '","new":"', escape_json(NEW.observaciones), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'animal_salud', OLD.animal_salud_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `animal_ubicaciones`
--

CREATE TABLE `animal_ubicaciones` (
  `animal_ubicacion_id` char(36) NOT NULL,
  `animal_id` char(36) NOT NULL,
  `finca_id` char(36) DEFAULT NULL,
  `aprisco_id` char(36) DEFAULT NULL,
  `area_id` char(36) DEFAULT NULL,
  `recinto_id` char(36) DEFAULT NULL,
  `fecha_desde` date NOT NULL,
  `fecha_hasta` date DEFAULT NULL,
  `motivo` enum('TRASLADO','INGRESO','EGRESO','AISLAMIENTO','VENTA','OTRO') NOT NULL DEFAULT 'OTRO',
  `estado` enum('ACTIVA','INACTIVA') NOT NULL DEFAULT 'ACTIVA',
  `observaciones` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `created_by` char(36) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `animal_ubicaciones`
--

INSERT INTO `animal_ubicaciones` (`animal_ubicacion_id`, `animal_id`, `finca_id`, `aprisco_id`, `area_id`, `recinto_id`, `fecha_desde`, `fecha_hasta`, `motivo`, `estado`, `observaciones`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('a0a31e07-4020-4ebe-900b-d294b5c7a3f4', 'l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', '06fcbfc8-ffc7-4956-b99d-77d879d772b7', '78059699-0f15-419e-89a8-fcc2697c4c97', '9927c9e7-d35a-4b1c-93b0-c078894cc9ef', '66de25f3-a5a7-4616-8148-7ce4513e4f04', '2025-11-09', NULL, 'TRASLADO', 'ACTIVA', '', '2025-11-09 10:56:10', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL);

--
-- Disparadores `animal_ubicaciones`
--
DELIMITER $$
CREATE TRIGGER `trg_animal_ubicaciones_delete` BEFORE DELETE ON `animal_ubicaciones` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'animal_ubicaciones', OLD.animal_ubicacion_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'animal_ubicacion_id', OLD.animal_ubicacion_id,
      'animal_id', OLD.animal_id,
      'finca_id', OLD.finca_id,
      'aprisco_id', OLD.aprisco_id,
      'area_id', OLD.area_id,
      'recinto_id', OLD.recinto_id,
      'fecha_desde', OLD.fecha_desde,
      'fecha_hasta', OLD.fecha_hasta,
      'motivo', OLD.motivo,
      'estado', OLD.estado,
      'observaciones', OLD.observaciones,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_animal_ubicaciones_delete_logical` AFTER UPDATE ON `animal_ubicaciones` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'animal_ubicaciones', OLD.animal_ubicacion_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'animal_ubicacion_id', OLD.animal_ubicacion_id,
        'animal_id', OLD.animal_id,
        'finca_id', OLD.finca_id,
        'aprisco_id', OLD.aprisco_id,
        'area_id', OLD.area_id,
        'recinto_id', OLD.recinto_id,
        'fecha_desde', OLD.fecha_desde,
        'fecha_hasta', OLD.fecha_hasta,
        'motivo', OLD.motivo,
        'estado', OLD.estado,
        'observaciones', OLD.observaciones,
        'created_at', OLD.created_at,
        'created_by', OLD.created_by,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_animal_ubicaciones_insert` AFTER INSERT ON `animal_ubicaciones` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'animal_ubicaciones', NEW.animal_ubicacion_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'animal_ubicacion_id', NEW.animal_ubicacion_id,
      'animal_id', NEW.animal_id,
      'finca_id', NEW.finca_id,
      'aprisco_id', NEW.aprisco_id,
      'area_id', NEW.area_id,
      'recinto_id', NEW.recinto_id,
      'fecha_desde', NEW.fecha_desde,
      'fecha_hasta', NEW.fecha_hasta,
      'motivo', NEW.motivo,
      'estado', NEW.estado,
      'observaciones', NEW.observaciones,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_animal_ubicaciones_update` AFTER UPDATE ON `animal_ubicaciones` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.animal_id <> NEW.animal_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"animal_id":{"old":"', escape_json(OLD.animal_id), '","new":"', escape_json(NEW.animal_id), '"}');
  END IF;
  IF OLD.finca_id <> NEW.finca_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"finca_id":{"old":"', escape_json(OLD.finca_id), '","new":"', escape_json(NEW.finca_id), '"}');
  END IF;
  IF OLD.aprisco_id <> NEW.aprisco_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"aprisco_id":{"old":"', escape_json(OLD.aprisco_id), '","new":"', escape_json(NEW.aprisco_id), '"}');
  END IF;
  IF OLD.area_id <> NEW.area_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"area_id":{"old":"', escape_json(OLD.area_id), '","new":"', escape_json(NEW.area_id), '"}');
  END IF;
  IF OLD.recinto_id <> NEW.recinto_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"recinto_id":{"old":"', escape_json(OLD.recinto_id), '","new":"', escape_json(NEW.recinto_id), '"}');
  END IF;
  IF OLD.fecha_desde <> NEW.fecha_desde THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"fecha_desde":{"old":"', escape_json(OLD.fecha_desde), '","new":"', escape_json(NEW.fecha_desde), '"}');
  END IF;
  IF OLD.fecha_hasta <> NEW.fecha_hasta THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"fecha_hasta":{"old":"', escape_json(OLD.fecha_hasta), '","new":"', escape_json(NEW.fecha_hasta), '"}');
  END IF;
  IF OLD.motivo <> NEW.motivo THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"motivo":{"old":"', escape_json(OLD.motivo), '","new":"', escape_json(NEW.motivo), '"}');
  END IF;
  IF OLD.estado <> NEW.estado THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"estado":{"old":"', escape_json(OLD.estado), '","new":"', escape_json(NEW.estado), '"}');
  END IF;
  IF OLD.observaciones <> NEW.observaciones THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"observaciones":{"old":"', escape_json(OLD.observaciones), '","new":"', escape_json(NEW.observaciones), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'animal_ubicaciones', OLD.animal_ubicacion_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `apriscos`
--

CREATE TABLE `apriscos` (
  `aprisco_id` char(36) NOT NULL,
  `finca_id` char(36) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by` char(36) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `apriscos`
--

INSERT INTO `apriscos` (`aprisco_id`, `finca_id`, `nombre`, `estado`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('12e9c31d-f8a0-44f7-aa7c-bfceeeacf217', 'dd4c7b22-1d63-4853-9d6b-d834564f9fbb', 'Aprisco2', 'ACTIVO', '2025-10-13 09:52:24', 'd7518474-2d2f-4634-823f-71936565c110', '2025-10-13 09:52:29', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL),
('6e978202-9e3e-474b-a353-3169f984d1f6', 'ebb1a1bc-2127-4563-b785-111623e7ebda', 'Aprisco3', 'ACTIVO', '2025-10-13 09:52:16', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('78059699-0f15-419e-89a8-fcc2697c4c97', '06fcbfc8-ffc7-4956-b99d-77d879d772b7', 'Aprisco Central Editado rd20er', 'ACTIVO', '2025-10-02 10:52:16', '78059699-0f15-419e-89a8-fcc2697c4c97', '2025-10-02 10:52:16', '78059699-0f15-419e-89a8-fcc2697c4c97', NULL, NULL),
('d71f5245-50c6-4698-a000-b2546a4c5f92', '1785adc9-285b-4a0d-88ea-cc5f66cdc851', 'Aprisco4', 'ACTIVO', '2025-10-13 09:52:06', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL);

--
-- Disparadores `apriscos`
--
DELIMITER $$
CREATE TRIGGER `trg_apriscos_delete` BEFORE DELETE ON `apriscos` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'apriscos', OLD.aprisco_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'aprisco_id', OLD.aprisco_id,
      'finca_id', OLD.finca_id,
      'nombre', OLD.nombre,
      'estado', OLD.estado,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_apriscos_delete_logical` AFTER UPDATE ON `apriscos` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'apriscos', OLD.aprisco_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'aprisco_id', OLD.aprisco_id,
        'finca_id', OLD.finca_id,
        'nombre', OLD.nombre,
        'estado', OLD.estado,
        'created_at', OLD.created_at,
        'created_by', OLD.created_by,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_apriscos_insert` AFTER INSERT ON `apriscos` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'apriscos', NEW.aprisco_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'aprisco_id', NEW.aprisco_id,
      'finca_id', NEW.finca_id,
      'nombre', NEW.nombre,
      'estado', NEW.estado,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_apriscos_update` AFTER UPDATE ON `apriscos` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.finca_id <> NEW.finca_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"finca_id":{"old":"', escape_json(OLD.finca_id), '","new":"', escape_json(NEW.finca_id), '"}');
  END IF;
  IF OLD.nombre <> NEW.nombre THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"nombre":{"old":"', escape_json(OLD.nombre), '","new":"', escape_json(NEW.nombre), '"}');
  END IF;
  IF OLD.estado <> NEW.estado THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"estado":{"old":"', escape_json(OLD.estado), '","new":"', escape_json(NEW.estado), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'apriscos', OLD.aprisco_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `areas`
--

CREATE TABLE `areas` (
  `area_id` char(36) NOT NULL,
  `aprisco_id` char(36) NOT NULL,
  `nombre_personalizado` varchar(120) DEFAULT NULL,
  `tipo_area` enum('LEVANTE_CEBA','GESTACION','MATERNIDAD','REPRODUCCION','CHIQUERO', 'CUARENTENA') NOT NULL,
  `numeracion` varchar(50) DEFAULT NULL,
  `estado` enum('ACTIVA','INACTIVA') NOT NULL DEFAULT 'ACTIVA',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by` char(36) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `areas`
--

INSERT INTO `areas` (`area_id`, `aprisco_id`, `nombre_personalizado`, `tipo_area`, `numeracion`, `estado`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('486a43b4-565a-45d8-af5c-5efc26fb54a0', '78059699-0f15-419e-89a8-fcc2697c4c97', 'fsafa', 'LEVANTE_CEBA', '242', 'ACTIVA', '2025-11-08 22:40:43', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('9927c9e7-d35a-4b1c-93b0-c078894cc9ef', '78059699-0f15-419e-89a8-fcc2697c4c97', 'Gestación-Edit-rd20er', 'GESTACION', '2', 'ACTIVA', '2025-10-02 10:52:16', '9927c9e7-d35a-4b1c-93b0-c078894cc9ef', '2025-10-02 10:52:17', '9927c9e7-d35a-4b1c-93b0-c078894cc9ef', NULL, NULL);

--
-- Disparadores `areas`
--
DELIMITER $$
CREATE TRIGGER `trg_areas_delete` BEFORE DELETE ON `areas` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'areas', OLD.area_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'area_id', OLD.area_id,
      'aprisco_id', OLD.aprisco_id,
      'nombre_personalizado', OLD.nombre_personalizado,
      'tipo_area', OLD.tipo_area,
      'numeracion', OLD.numeracion,
      'estado', OLD.estado,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_areas_delete_logical` AFTER UPDATE ON `areas` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'areas', OLD.area_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'area_id', OLD.area_id,
        'aprisco_id', OLD.aprisco_id,
        'nombre_personalizado', OLD.nombre_personalizado,
        'tipo_area', OLD.tipo_area,
        'numeracion', OLD.numeracion,
        'estado', OLD.estado,
        'created_at', OLD.created_at,
        'created_by', OLD.created_by,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_areas_insert` AFTER INSERT ON `areas` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'areas', NEW.area_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'area_id', NEW.area_id,
      'aprisco_id', NEW.aprisco_id,
      'nombre_personalizado', NEW.nombre_personalizado,
      'tipo_area', NEW.tipo_area,
      'numeracion', NEW.numeracion,
      'estado', NEW.estado,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_areas_update` AFTER UPDATE ON `areas` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.aprisco_id <> NEW.aprisco_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"aprisco_id":{"old":"', escape_json(OLD.aprisco_id), '","new":"', escape_json(NEW.aprisco_id), '"}');
  END IF;
  IF OLD.nombre_personalizado <> NEW.nombre_personalizado THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"nombre_personalizado":{"old":"', escape_json(OLD.nombre_personalizado), '","new":"', escape_json(NEW.nombre_personalizado), '"}');
  END IF;
  IF OLD.tipo_area <> NEW.tipo_area THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"tipo_area":{"old":"', escape_json(OLD.tipo_area), '","new":"', escape_json(NEW.tipo_area), '"}');
  END IF;
  IF OLD.numeracion <> NEW.numeracion THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"numeracion":{"old":"', escape_json(OLD.numeracion), '","new":"', escape_json(NEW.numeracion), '"}');
  END IF;
  IF OLD.estado <> NEW.estado THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"estado":{"old":"', escape_json(OLD.estado), '","new":"', escape_json(NEW.estado), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'areas', OLD.area_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audit_log`
--

CREATE TABLE `audit_log` (
  `audit_id` bigint(20) NOT NULL,
  `table_name` varchar(100) NOT NULL,
  `record_id` varchar(100) NOT NULL,
  `action_type` enum('UPDATE','DELETE_LOGICAL','DELETE_PHYSICAL','INSERT') NOT NULL,
  `action_by` char(36) NOT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `user_type` varchar(255) DEFAULT NULL,
  `action_timestamp` datetime DEFAULT current_timestamp(),
  `action_timezone` varchar(255) DEFAULT NULL,
  `changes` text DEFAULT NULL,
  `full_row` longtext DEFAULT NULL,
  `client_ip` varchar(45) DEFAULT NULL,
  `client_hostname` varchar(100) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `client_os` varchar(50) DEFAULT NULL,
  `client_browser` varchar(50) DEFAULT NULL,
  `domain_name` varchar(100) DEFAULT NULL,
  `request_uri` varchar(200) DEFAULT NULL,
  `server_hostname` varchar(100) DEFAULT NULL,
  `client_country` varchar(255) NOT NULL,
  `client_region` varchar(255) NOT NULL,
  `client_city` varchar(255) NOT NULL,
  `client_zipcode` varchar(255) NOT NULL,
  `client_coordinates` varchar(255) NOT NULL,
  `geo_ip_timestamp` datetime DEFAULT NULL,
  `geo_ip_timezone` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `audit_log`
--

INSERT INTO `audit_log` (`audit_id`, `table_name`, `record_id`, `action_type`, `action_by`, `full_name`, `user_type`, `action_timestamp`, `action_timezone`, `changes`, `full_row`, `client_ip`, `client_hostname`, `user_agent`, `client_os`, `client_browser`, `domain_name`, `request_uri`, `server_hostname`, `client_country`, `client_region`, `client_city`, `client_zipcode`, `client_coordinates`, `geo_ip_timestamp`, `geo_ip_timezone`) VALUES
(3, 'system_users', '202b02fa-053d-48d5-a307-b52adb5525f4', 'UPDATE', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moises', '0', '2025-11-07 12:02:32', 'America/Caracas', '{\"nombre\":{\"old\":\"Moises\",\"new\":\"Moisess\"},\"updated_at\":{\"old\":\"2025-11-07 12:00:55\",\"new\":\"2025-11-07 12:02:32\"}}', NULL, '::1', 'DESKTOP-BRTU0R4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/system_users/202b02fa-053d-48d5-a307-b52adb5525f4', 'DESKTOP-BRTU0R4', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-07 12:02:32', 'America/Caracas'),
(6, 'incidencias', 'f1c521d5-bcd3-4d7a-b1c6-ded5c9bc1192', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-08 20:56:05', 'America/Caracas', NULL, '{\"incidencia_id\": \"f1c521d5-bcd3-4d7a-b1c6-ded5c9bc1192\", \"animal_id\": \"ab29db65-86d8-46c6-bc47-85a988176e4a\", \"tipo\": \"RINA\", \"fecha_evento\": \"2025-11-08 20:54:00\", \"descripcion\": null, \"responsable\": null, \"area_id\": \"9927c9e7-d35a-4b1c-93b0-c078894cc9ef\", \"created_at\": \"2025-11-08 20:56:05\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '96.31.87.186', '96-31-87-186.static.hvvc.us', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36', 'Linux', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/incidencias', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-08 20:56:05', 'America/Caracas'),
(7, 'incidencias', 'f1c521d5-bcd3-4d7a-b1c6-ded5c9bc1192', 'DELETE_LOGICAL', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-08 20:56:34', 'America/Caracas', '{\"deleted_at\": {\"old\": null, \"new\": \"2025-11-08 20:56:34\"}}', '{\"incidencia_id\": \"f1c521d5-bcd3-4d7a-b1c6-ded5c9bc1192\", \"animal_id\": \"ab29db65-86d8-46c6-bc47-85a988176e4a\", \"tipo\": \"RINA\", \"fecha_evento\": \"2025-11-08 20:54:00\", \"descripcion\": null, \"responsable\": null, \"area_id\": \"9927c9e7-d35a-4b1c-93b0-c078894cc9ef\", \"created_at\": \"2025-11-08 20:56:05\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\", \"updated_at\": null, \"updated_by\": null, \"deleted_at\": \"2025-11-08 20:56:34\", \"deleted_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '96.31.87.170', '96-31-87-170.static.hvvc.us', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36', 'Linux', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/incidencias/f1c521d5-bcd3-4d7a-b1c6-ded5c9bc1192', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-08 20:56:34', 'America/Caracas'),
(8, 'incidencias', '6b89b7e0-5986-4bde-9ce4-058eecf40682', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-08 21:02:53', 'America/Caracas', NULL, '{\"incidencia_id\": \"6b89b7e0-5986-4bde-9ce4-058eecf40682\", \"animal_id\": \"ab29db65-86d8-46c6-bc47-85a988176e4a\", \"tipo\": \"APLASTAMIENTO\", \"fecha_evento\": \"2025-11-08 21:02:00\", \"descripcion\": null, \"responsable\": null, \"area_id\": \"9927c9e7-d35a-4b1c-93b0-c078894cc9ef\", \"created_at\": \"2025-11-08 21:02:53\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '96.31.87.141', '96-31-87-141.static.hvvc.us', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36', 'Linux', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/incidencias', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-08 21:02:53', 'America/Caracas'),
(9, 'system_users', '202b02fa-053d-48d5-a307-b52adb5525f4', 'UPDATE', 'e2e51742-d956-47ed-a42d-851a89cf3029', 'Unknown', 'Unknown', '2025-11-08 21:31:49', 'America/Caracas', '{\"updated_at\":{\"old\":\"2025-11-07 12:02:32\",\"new\":\"2025-11-08 21:31:49\"}}', NULL, '200.8.108.95', '200.8.108.95', 'Dalvik/2.1.0 (Linux; U; Android 15; 2412DPC0AG Build/AP3A.240905.015.A2)', 'Linux', 'Unknown Browser', 'sigob.net', '/ERP_SISUPP/api/system_users/login_app', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-08 21:31:49', 'America/Caracas'),
(10, 'incidencias', '7b30d53d-8e74-4290-a5c7-3f6a8bb95d75', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-08 21:48:17', 'America/Caracas', NULL, '{\"incidencia_id\": \"7b30d53d-8e74-4290-a5c7-3f6a8bb95d75\", \"animal_id\": \"ab29db65-86d8-46c6-bc47-85a988176e4a\", \"tipo\": \"RINA\", \"fecha_evento\": \"2025-11-08 21:48:00\", \"descripcion\": \"fsa\", \"responsable\": \"fsa\", \"area_id\": \"9927c9e7-d35a-4b1c-93b0-c078894cc9ef\", \"created_at\": \"2025-11-08 21:48:17\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '96.31.87.156', '96-31-87-156.static.hvvc.us', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/incidencias', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-08 21:48:17', 'America/Caracas'),
(11, 'incidencias', '5df96cef-22c1-4928-933e-ab1bfc493be0', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-08 22:17:13', 'America/Caracas', NULL, '{\"incidencia_id\": \"5df96cef-22c1-4928-933e-ab1bfc493be0\", \"animal_id\": \"ab29db65-86d8-46c6-bc47-85a988176e4a\", \"tipo\": \"RINA\", \"fecha_evento\": \"2025-11-08 22:17:00\", \"descripcion\": \"fsa\", \"responsable\": \"fsa\", \"area_id\": \"9927c9e7-d35a-4b1c-93b0-c078894cc9ef\", \"created_at\": \"2025-11-08 22:17:13\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '96.31.87.163', '96-31-87-163.static.hvvc.us', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/incidencias', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-08 22:17:13', 'America/Caracas'),
(14, 'areas', '486a43b4-565a-45d8-af5c-5efc26fb54a0', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-08 22:40:43', 'America/Caracas', NULL, '{\"area_id\": \"486a43b4-565a-45d8-af5c-5efc26fb54a0\", \"aprisco_id\": \"78059699-0f15-419e-89a8-fcc2697c4c97\", \"nombre_personalizado\": \"fsafa\", \"tipo_area\": \"LEVANTE_CEBA\", \"numeracion\": \"242\", \"estado\": \"ACTIVA\", \"created_at\": \"2025-11-08 22:40:43\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '96.31.87.150', '96-31-87-150.static.hvvc.us', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36', 'Linux', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/areas', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-08 22:40:43', 'America/Caracas'),
(15, 'recintos', '66de25f3-a5a7-4616-8148-7ce4513e4f04', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 10:55:55', 'America/Caracas', NULL, '{\"recinto_id\": \"66de25f3-a5a7-4616-8148-7ce4513e4f04\", \"area_id\": \"9927c9e7-d35a-4b1c-93b0-c078894cc9ef\", \"codigo_recinto\": \"rec_01\", \"capacidad\": 100, \"estado\": \"ACTIVO\", \"observaciones\": null, \"created_at\": \"2025-11-09 10:55:55\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '96.31.87.187', '96-31-87-187.static.hvvc.us', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/recintos', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 10:55:55', 'America/Caracas'),
(16, 'animal_ubicaciones', 'a0a31e07-4020-4ebe-900b-d294b5c7a3f4', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 10:56:10', 'America/Caracas', NULL, '{\"animal_ubicacion_id\": \"a0a31e07-4020-4ebe-900b-d294b5c7a3f4\", \"animal_id\": \"l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0\", \"finca_id\": \"06fcbfc8-ffc7-4956-b99d-77d879d772b7\", \"aprisco_id\": \"78059699-0f15-419e-89a8-fcc2697c4c97\", \"area_id\": \"9927c9e7-d35a-4b1c-93b0-c078894cc9ef\", \"recinto_id\": \"66de25f3-a5a7-4616-8148-7ce4513e4f04\", \"fecha_desde\": \"2025-11-09\", \"fecha_hasta\": null, \"motivo\": \"TRASLADO\", \"estado\": \"ACTIVA\", \"observaciones\": \"\", \"created_at\": \"2025-11-09 10:56:10\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '96.31.87.187', '96-31-87-187.static.hvvc.us', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/animal_ubicaciones', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 10:56:10', 'America/Caracas'),
(17, 'partos', '44b8bebe-577d-4fa1-8d8d-aa61cbb87e08', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 10:56:33', 'America/Caracas', NULL, '{\"parto_id\": \"44b8bebe-577d-4fa1-8d8d-aa61cbb87e08\", \"periodo_id\": \"ec12cdac-0816-4ec5-90cf-19249ea3b394\", \"fecha_parto\": \"2025-11-09\", \"crias_machos\": 10, \"crias_hembras\": 10, \"peso_promedio_kg\": null, \"estado_parto\": \"NORMAL\", \"observaciones\": \"\", \"created_at\": \"2025-11-09 10:56:33\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '96.31.87.149', '96-31-87-149.static.hvvc.us', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/partos', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 10:56:33', 'America/Caracas'),
(18, 'camadas', '56ef9c0f-3d2e-46c6-ab4d-ddb99696b833', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 10:56:33', 'America/Caracas', NULL, '{\"camada_id\": \"56ef9c0f-3d2e-46c6-ab4d-ddb99696b833\", \"parto_id\": \"44b8bebe-577d-4fa1-8d8d-aa61cbb87e08\", \"madre_id\": \"l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0\", \"cantidad_inicial\": 20, \"estado_camada\": \"ACTIVA\", \"created_at\": \"2025-11-09 10:56:33\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '96.31.87.149', '96-31-87-149.static.hvvc.us', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/partos', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 10:56:33', 'America/Caracas'),
(19, 'animal_movimientos', '8fd9c4d8-020e-47dc-a0a8-95164481f6ad', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 10:56:33', 'America/Caracas', NULL, '{\"animal_movimiento_id\": \"8fd9c4d8-020e-47dc-a0a8-95164481f6ad\", \"animal_id\": \"l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0\", \"fecha_mov\": \"2025-11-09\", \"tipo_movimiento\": \"TRASLADO\", \"motivo\": \"TRASLADO\", \"estado\": \"REGISTRADO\", \"finca_origen_id\": \"06fcbfc8-ffc7-4956-b99d-77d879d772b7\", \"aprisco_origen_id\": \"78059699-0f15-419e-89a8-fcc2697c4c97\", \"area_origen_id\": \"9927c9e7-d35a-4b1c-93b0-c078894cc9ef\", \"recinto_id_origen\": \"66de25f3-a5a7-4616-8148-7ce4513e4f04\", \"finca_destino_id\": \"06fcbfc8-ffc7-4956-b99d-77d879d772b7\", \"aprisco_destino_id\": \"78059699-0f15-419e-89a8-fcc2697c4c97\", \"area_destino_id\": \"9927c9e7-d35a-4b1c-93b0-c078894cc9ef\", \"recinto_id_destino\": \"66de25f3-a5a7-4616-8148-7ce4513e4f04\", \"costo\": null, \"documento_ref\": null, \"observaciones\": \"Traslado por parto a maternidad.\", \"created_at\": \"2025-11-09 10:56:33\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '96.31.87.149', '96-31-87-149.static.hvvc.us', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/partos', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 10:56:33', 'America/Caracas'),
(20, 'camada_bajas', '9e833325-aeed-4833-b3b1-70633c07d58f', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 10:56:50', 'America/Caracas', NULL, '{\"baja_id\": \"9e833325-aeed-4833-b3b1-70633c07d58f\", \"camada_id\": \"56ef9c0f-3d2e-46c6-ab4d-ddb99696b833\", \"fecha_baja\": \"2025-11-09\", \"cantidad\": 1, \"causa_deceso\": \"APLASTAMIENTO\", \"documento_acta_url\": null, \"observaciones\": \"fsafa\", \"created_at\": \"2025-11-09 10:56:50\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '96.31.87.149', '96-31-87-149.static.hvvc.us', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/camadas/56ef9c0f-3d2e-46c6-ab4d-ddb99696b833/bajas', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 10:56:50', 'America/Caracas'),
(21, 'incidencias', 'ad09d518-2565-4a4c-a0f0-294be309f6c0', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 10:56:50', 'America/Caracas', NULL, '{\"incidencia_id\": \"ad09d518-2565-4a4c-a0f0-294be309f6c0\", \"animal_id\": \"l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0\", \"tipo\": \"APLASTAMIENTO\", \"fecha_evento\": \"2025-11-09 00:00:00\", \"descripcion\": \"Aplastamiento de 1 lechón(es). Baja registrada.\", \"responsable\": \"sistema\", \"area_id\": null, \"created_at\": \"2025-11-09 10:56:50\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '96.31.87.149', '96-31-87-149.static.hvvc.us', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/camadas/56ef9c0f-3d2e-46c6-ab4d-ddb99696b833/bajas', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 10:56:50', 'America/Caracas'),
(22, 'incidencias', '5df96cef-22c1-4928-933e-ab1bfc493be0', 'DELETE_LOGICAL', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 10:58:43', 'America/Caracas', '{\"deleted_at\": {\"old\": null, \"new\": \"2025-11-09 10:58:43\"}}', '{\"incidencia_id\": \"5df96cef-22c1-4928-933e-ab1bfc493be0\", \"animal_id\": \"ab29db65-86d8-46c6-bc47-85a988176e4a\", \"tipo\": \"RINA\", \"fecha_evento\": \"2025-11-08 22:17:00\", \"descripcion\": \"fsa\", \"responsable\": \"fsa\", \"area_id\": \"9927c9e7-d35a-4b1c-93b0-c078894cc9ef\", \"created_at\": \"2025-11-08 22:17:13\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\", \"updated_at\": null, \"updated_by\": null, \"deleted_at\": \"2025-11-09 10:58:43\", \"deleted_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '96.31.87.149', '96-31-87-149.static.hvvc.us', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/incidencias/5df96cef-22c1-4928-933e-ab1bfc493be0', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 10:58:43', 'America/Caracas'),
(23, 'incidencias', '7b30d53d-8e74-4290-a5c7-3f6a8bb95d75', 'DELETE_LOGICAL', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 11:03:29', 'America/Caracas', '{\"deleted_at\": {\"old\": null, \"new\": \"2025-11-09 11:03:29\"}}', '{\"incidencia_id\": \"7b30d53d-8e74-4290-a5c7-3f6a8bb95d75\", \"animal_id\": \"ab29db65-86d8-46c6-bc47-85a988176e4a\", \"tipo\": \"RINA\", \"fecha_evento\": \"2025-11-08 21:48:00\", \"descripcion\": \"fsa\", \"responsable\": \"fsa\", \"area_id\": \"9927c9e7-d35a-4b1c-93b0-c078894cc9ef\", \"created_at\": \"2025-11-08 21:48:17\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\", \"updated_at\": null, \"updated_by\": null, \"deleted_at\": \"2025-11-09 11:03:29\", \"deleted_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '96.31.87.154', '96-31-87-154.static.hvvc.us', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/incidencias/7b30d53d-8e74-4290-a5c7-3f6a8bb95d75', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 11:03:29', 'America/Caracas'),
(24, 'system_users', '202b02fa-053d-48d5-a307-b52adb5525f4', 'UPDATE', 'cff44793-2857-42a0-916d-4ca23c9c458c', 'Unknown', 'Unknown', '2025-11-09 11:37:50', 'America/Caracas', '{\"updated_at\":{\"old\":\"2025-11-08 21:31:49\",\"new\":\"2025-11-09 11:37:50\"}}', NULL, '200.8.108.95', '200.8.108.95', 'Dalvik/2.1.0 (Linux; U; Android 15; 2412DPC0AG Build/AP3A.240905.015.A2)', 'Linux', 'Unknown Browser', 'sigob.net', '/ERP_SISUPP/api/system_users/login_app', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 11:37:50', 'America/Caracas'),
(25, 'periodos_servicio', '220d5f3b-2cd3-404a-ba77-dd0e8f821ac3', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-09 12:49:18', 'SYSTEM', NULL, '{\"periodo_id\": \"220d5f3b-2cd3-404a-ba77-dd0e8f821ac3\", \"hembra_id\": \"l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0\", \"verraco_id\": \"k12c3441-b7f6-4af3-8a9e-43df2b28aee7\", \"fecha_inicio\": \"2025-11-09\", \"hora_servicio\": \"12:49:00\", \"frecuencia_servicios\": \"diaria\", \"numero_servicios\": 1, \"observaciones\": \"\", \"estado_periodo\": \"ABIERTO\", \"created_at\": \"2025-11-09 16:49:18\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:49:18', 'SYSTEM'),
(26, 'servicios', '11884304-8c96-4936-a87f-0e478315a313', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-09 12:49:18', 'SYSTEM', NULL, '{\"monta_id\": \"11884304-8c96-4936-a87f-0e478315a313\", \"periodo_id\": \"220d5f3b-2cd3-404a-ba77-dd0e8f821ac3\", \"numero_monta\": 1, \"fecha_monta\": \"2025-11-10 12:49:00\", \"estatus\": \"PENDIENTE\", \"created_at\": \"2025-11-09 16:49:18\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:49:18', 'SYSTEM'),
(27, 'periodos_servicio', '220d5f3b-2cd3-404a-ba77-dd0e8f821ac3', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-09 12:49:26', 'SYSTEM', '{\"estado_periodo\":{\"old\":\"ABIERTO\",\"new\":\"\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:49:26', 'SYSTEM'),
(28, 'servicios', '11884304-8c96-4936-a87f-0e478315a313', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-09 12:49:26', 'SYSTEM', '{\"estatus\":{\"old\":\"PENDIENTE\",\"new\":\"REALIZADO\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:49:26', 'SYSTEM'),
(29, 'revisiones_servicio', '703c41eb-98df-4185-8065-f5d1c3288b07', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-09 12:49:26', 'SYSTEM', NULL, '{\"revision_id\": \"703c41eb-98df-4185-8065-f5d1c3288b07\", \"periodo_id\": \"220d5f3b-2cd3-404a-ba77-dd0e8f821ac3\", \"ciclo_control\": 1, \"fecha_programada\": \"2025-11-30\", \"fecha_realizada\": null, \"resultado\": null, \"observaciones\": null, \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\", \"created_at\": \"2025-11-09 12:49:26\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:49:26', 'SYSTEM'),
(30, 'periodos_servicio', '220d5f3b-2cd3-404a-ba77-dd0e8f821ac3', 'UPDATE', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 12:50:04', 'America/Caracas', '{\"estado_periodo\":{\"old\":\"\",\"new\":\"CERRADO\"}}', NULL, '96.31.87.190', '96-31-87-190.static.hvvc.us', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/revisiones-servicio/703c41eb-98df-4185-8065-f5d1c3288b07', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 12:50:04', 'America/Caracas'),
(31, 'periodos_servicio', 'd1ed07a3-a564-4174-a7bb-7c31b1d573c3', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-09 12:51:08', 'SYSTEM', NULL, '{\"periodo_id\": \"d1ed07a3-a564-4174-a7bb-7c31b1d573c3\", \"hembra_id\": \"l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0\", \"verraco_id\": \"k12c3441-b7f6-4af3-8a9e-43df2b28aee7\", \"fecha_inicio\": \"2025-11-09\", \"hora_servicio\": \"12:51:00\", \"frecuencia_servicios\": \"diaria\", \"numero_servicios\": 5, \"observaciones\": \"\", \"estado_periodo\": \"ABIERTO\", \"created_at\": \"2025-11-09 16:51:08\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:51:08', 'SYSTEM'),
(32, 'servicios', '95b38af2-f3bf-46d2-95d9-94db73fcfb3f', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-09 12:51:08', 'SYSTEM', NULL, '{\"monta_id\": \"95b38af2-f3bf-46d2-95d9-94db73fcfb3f\", \"periodo_id\": \"d1ed07a3-a564-4174-a7bb-7c31b1d573c3\", \"numero_monta\": 1, \"fecha_monta\": \"2025-11-10 12:51:00\", \"estatus\": \"PENDIENTE\", \"created_at\": \"2025-11-09 16:51:08\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:51:08', 'SYSTEM'),
(33, 'servicios', '2a3415e5-4303-40f1-b6f1-2f4717aed08c', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-09 12:51:08', 'SYSTEM', NULL, '{\"monta_id\": \"2a3415e5-4303-40f1-b6f1-2f4717aed08c\", \"periodo_id\": \"d1ed07a3-a564-4174-a7bb-7c31b1d573c3\", \"numero_monta\": 2, \"fecha_monta\": \"2025-11-11 12:51:00\", \"estatus\": \"PENDIENTE\", \"created_at\": \"2025-11-09 16:51:08\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:51:08', 'SYSTEM'),
(34, 'servicios', 'd2e0a875-2238-4329-89bd-16b11b6bcea0', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-09 12:51:08', 'SYSTEM', NULL, '{\"monta_id\": \"d2e0a875-2238-4329-89bd-16b11b6bcea0\", \"periodo_id\": \"d1ed07a3-a564-4174-a7bb-7c31b1d573c3\", \"numero_monta\": 3, \"fecha_monta\": \"2025-11-12 12:51:00\", \"estatus\": \"PENDIENTE\", \"created_at\": \"2025-11-09 16:51:08\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:51:08', 'SYSTEM'),
(35, 'servicios', 'd571c78b-c6d3-4d2a-b998-20113ee624a7', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-09 12:51:08', 'SYSTEM', NULL, '{\"monta_id\": \"d571c78b-c6d3-4d2a-b998-20113ee624a7\", \"periodo_id\": \"d1ed07a3-a564-4174-a7bb-7c31b1d573c3\", \"numero_monta\": 4, \"fecha_monta\": \"2025-11-13 12:51:00\", \"estatus\": \"PENDIENTE\", \"created_at\": \"2025-11-09 16:51:08\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:51:08', 'SYSTEM'),
(36, 'servicios', '5b9bcaf0-c49a-4e39-b489-47abf3d49667', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-09 12:51:08', 'SYSTEM', NULL, '{\"monta_id\": \"5b9bcaf0-c49a-4e39-b489-47abf3d49667\", \"periodo_id\": \"d1ed07a3-a564-4174-a7bb-7c31b1d573c3\", \"numero_monta\": 5, \"fecha_monta\": \"2025-11-14 12:51:00\", \"estatus\": \"PENDIENTE\", \"created_at\": \"2025-11-09 16:51:08\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:51:08', 'SYSTEM'),
(37, 'periodos_servicio', 'd1ed07a3-a564-4174-a7bb-7c31b1d573c3', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-09 12:51:11', 'SYSTEM', '{\"estado_periodo\":{\"old\":\"ABIERTO\",\"new\":\"\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:51:11', 'SYSTEM'),
(38, 'servicios', '2a3415e5-4303-40f1-b6f1-2f4717aed08c', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-09 12:51:11', 'SYSTEM', '{\"estatus\":{\"old\":\"PENDIENTE\",\"new\":\"REALIZADO\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:51:11', 'SYSTEM'),
(39, 'servicios', '5b9bcaf0-c49a-4e39-b489-47abf3d49667', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-09 12:51:11', 'SYSTEM', '{\"estatus\":{\"old\":\"PENDIENTE\",\"new\":\"REALIZADO\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:51:11', 'SYSTEM'),
(40, 'servicios', '95b38af2-f3bf-46d2-95d9-94db73fcfb3f', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-09 12:51:11', 'SYSTEM', '{\"estatus\":{\"old\":\"PENDIENTE\",\"new\":\"REALIZADO\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:51:11', 'SYSTEM'),
(41, 'servicios', 'd2e0a875-2238-4329-89bd-16b11b6bcea0', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-09 12:51:11', 'SYSTEM', '{\"estatus\":{\"old\":\"PENDIENTE\",\"new\":\"REALIZADO\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:51:11', 'SYSTEM'),
(42, 'servicios', 'd571c78b-c6d3-4d2a-b998-20113ee624a7', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-09 12:51:11', 'SYSTEM', '{\"estatus\":{\"old\":\"PENDIENTE\",\"new\":\"REALIZADO\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:51:11', 'SYSTEM'),
(43, 'revisiones_servicio', '3339bfbe-301c-475b-905e-348e5b7bcd7f', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-09 12:51:11', 'SYSTEM', NULL, '{\"revision_id\": \"3339bfbe-301c-475b-905e-348e5b7bcd7f\", \"periodo_id\": \"d1ed07a3-a564-4174-a7bb-7c31b1d573c3\", \"ciclo_control\": 1, \"fecha_programada\": \"2025-11-30\", \"fecha_realizada\": null, \"resultado\": null, \"observaciones\": null, \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\", \"created_at\": \"2025-11-09 12:51:11\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:51:11', 'SYSTEM'),
(44, 'periodos_servicio', 'd1ed07a3-a564-4174-a7bb-7c31b1d573c3', 'UPDATE', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 12:51:28', 'America/Caracas', '{\"estado_periodo\":{\"old\":\"\",\"new\":\"CERRADO\"}}', NULL, '96.31.87.190', '96-31-87-190.static.hvvc.us', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/revisiones-servicio/3339bfbe-301c-475b-905e-348e5b7bcd7f', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 12:51:28', 'America/Caracas'),
(45, 'revisiones_servicio', 'c25f49ca-dee5-48d4-89c5-81674a70933c', 'UPDATE', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 12:51:45', 'America/Caracas', '{\"ciclo_control\":{\"old\":\"1\",\"new\":\"2\"},\"fecha_programada\":{\"old\":\"2025-11-13\",\"new\":\"2025-12-04\"}}', NULL, '96.31.87.190', '96-31-87-190.static.hvvc.us', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/revisiones-servicio/c25f49ca-dee5-48d4-89c5-81674a70933c', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 12:51:45', 'America/Caracas'),
(46, 'revisiones_servicio', 'c25f49ca-dee5-48d4-89c5-81674a70933c', 'UPDATE', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 12:52:03', 'America/Caracas', '{\"resultado\":{\"old\":\"SOSPECHA_PREÑEZ\",\"new\":\"ENTRO_EN_CELO\"},\"updated_at\":{\"old\":\"2025-11-09 12:51:45\",\"new\":\"2025-11-09 12:52:03\"}}', NULL, '96.31.87.190', '96-31-87-190.static.hvvc.us', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36', 'Linux', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/revisiones-servicio/c25f49ca-dee5-48d4-89c5-81674a70933c', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 12:52:03', 'America/Caracas'),
(47, 'periodos_servicio', '752433b6-70fd-41f4-a5b4-72d055b121e4', 'UPDATE', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 12:52:03', 'America/Caracas', '{\"estado_periodo\":{\"old\":\"\",\"new\":\"CERRADO\"}}', NULL, '96.31.87.190', '96-31-87-190.static.hvvc.us', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36', 'Linux', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/revisiones-servicio/c25f49ca-dee5-48d4-89c5-81674a70933c', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 12:52:03', 'America/Caracas'),
(48, 'periodos_servicio', '7b222c37-bc28-43be-921a-d1c9539c45ab', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-09 12:52:47', 'SYSTEM', NULL, '{\"periodo_id\": \"7b222c37-bc28-43be-921a-d1c9539c45ab\", \"hembra_id\": \"l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0\", \"verraco_id\": \"k12c3441-b7f6-4af3-8a9e-43df2b28aee7\", \"fecha_inicio\": \"2025-11-09\", \"hora_servicio\": \"12:52:00\", \"frecuencia_servicios\": \"diaria\", \"numero_servicios\": 5, \"observaciones\": \"\", \"estado_periodo\": \"ABIERTO\", \"created_at\": \"2025-11-09 16:52:47\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:52:47', 'SYSTEM'),
(49, 'servicios', '4c2ff4e1-95f9-453f-9bd8-e918787a540d', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-09 12:52:47', 'SYSTEM', NULL, '{\"monta_id\": \"4c2ff4e1-95f9-453f-9bd8-e918787a540d\", \"periodo_id\": \"7b222c37-bc28-43be-921a-d1c9539c45ab\", \"numero_monta\": 1, \"fecha_monta\": \"2025-11-10 12:52:00\", \"estatus\": \"PENDIENTE\", \"created_at\": \"2025-11-09 16:52:47\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:52:47', 'SYSTEM'),
(50, 'servicios', '7e09266f-e4ee-4c43-afdf-dbcd34a5c591', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-09 12:52:47', 'SYSTEM', NULL, '{\"monta_id\": \"7e09266f-e4ee-4c43-afdf-dbcd34a5c591\", \"periodo_id\": \"7b222c37-bc28-43be-921a-d1c9539c45ab\", \"numero_monta\": 2, \"fecha_monta\": \"2025-11-11 12:52:00\", \"estatus\": \"PENDIENTE\", \"created_at\": \"2025-11-09 16:52:47\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:52:47', 'SYSTEM'),
(51, 'servicios', 'ad1c8cfd-22e3-4a17-8e57-940a8258c44f', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-09 12:52:47', 'SYSTEM', NULL, '{\"monta_id\": \"ad1c8cfd-22e3-4a17-8e57-940a8258c44f\", \"periodo_id\": \"7b222c37-bc28-43be-921a-d1c9539c45ab\", \"numero_monta\": 3, \"fecha_monta\": \"2025-11-12 12:52:00\", \"estatus\": \"PENDIENTE\", \"created_at\": \"2025-11-09 16:52:47\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:52:47', 'SYSTEM'),
(52, 'servicios', '9409cb31-2f32-4f49-9120-444f6f0c6c5d', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-09 12:52:47', 'SYSTEM', NULL, '{\"monta_id\": \"9409cb31-2f32-4f49-9120-444f6f0c6c5d\", \"periodo_id\": \"7b222c37-bc28-43be-921a-d1c9539c45ab\", \"numero_monta\": 4, \"fecha_monta\": \"2025-11-13 12:52:00\", \"estatus\": \"PENDIENTE\", \"created_at\": \"2025-11-09 16:52:47\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:52:47', 'SYSTEM'),
(53, 'servicios', 'aa2501d8-d064-49f7-8467-eaf0ab71f498', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-09 12:52:47', 'SYSTEM', NULL, '{\"monta_id\": \"aa2501d8-d064-49f7-8467-eaf0ab71f498\", \"periodo_id\": \"7b222c37-bc28-43be-921a-d1c9539c45ab\", \"numero_monta\": 5, \"fecha_monta\": \"2025-11-14 12:52:00\", \"estatus\": \"PENDIENTE\", \"created_at\": \"2025-11-09 16:52:47\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:52:47', 'SYSTEM'),
(54, 'periodos_servicio', '7b222c37-bc28-43be-921a-d1c9539c45ab', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-09 12:52:50', 'SYSTEM', '{\"estado_periodo\":{\"old\":\"ABIERTO\",\"new\":\"\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:52:50', 'SYSTEM'),
(55, 'servicios', '4c2ff4e1-95f9-453f-9bd8-e918787a540d', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-09 12:52:50', 'SYSTEM', '{\"estatus\":{\"old\":\"PENDIENTE\",\"new\":\"REALIZADO\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:52:50', 'SYSTEM'),
(56, 'servicios', '7e09266f-e4ee-4c43-afdf-dbcd34a5c591', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-09 12:52:50', 'SYSTEM', '{\"estatus\":{\"old\":\"PENDIENTE\",\"new\":\"REALIZADO\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:52:50', 'SYSTEM'),
(57, 'servicios', 'ad1c8cfd-22e3-4a17-8e57-940a8258c44f', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-09 12:52:50', 'SYSTEM', '{\"estatus\":{\"old\":\"PENDIENTE\",\"new\":\"REALIZADO\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:52:50', 'SYSTEM'),
(58, 'servicios', '9409cb31-2f32-4f49-9120-444f6f0c6c5d', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-09 12:52:50', 'SYSTEM', '{\"estatus\":{\"old\":\"PENDIENTE\",\"new\":\"REALIZADO\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:52:50', 'SYSTEM'),
(59, 'servicios', 'aa2501d8-d064-49f7-8467-eaf0ab71f498', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-09 12:52:50', 'SYSTEM', '{\"estatus\":{\"old\":\"PENDIENTE\",\"new\":\"REALIZADO\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:52:50', 'SYSTEM'),
(60, 'revisiones_servicio', '0d563d0e-cdd1-4a12-abd7-f1ad724a9988', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-09 12:52:50', 'SYSTEM', NULL, '{\"revision_id\": \"0d563d0e-cdd1-4a12-abd7-f1ad724a9988\", \"periodo_id\": \"7b222c37-bc28-43be-921a-d1c9539c45ab\", \"ciclo_control\": 1, \"fecha_programada\": \"2025-11-30\", \"fecha_realizada\": null, \"resultado\": null, \"observaciones\": null, \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\", \"created_at\": \"2025-11-09 12:52:50\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-09 12:52:50', 'SYSTEM'),
(61, 'revisiones_servicio', '0d563d0e-cdd1-4a12-abd7-f1ad724a9988', 'UPDATE', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 12:53:06', 'America/Caracas', '{\"ciclo_control\":{\"old\":\"1\",\"new\":\"2\"},\"fecha_programada\":{\"old\":\"2025-11-30\",\"new\":\"2025-12-21\"}}', NULL, '96.31.87.190', '96-31-87-190.static.hvvc.us', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/revisiones-servicio/0d563d0e-cdd1-4a12-abd7-f1ad724a9988', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 12:53:06', 'America/Caracas'),
(62, 'revisiones_servicio', '0d563d0e-cdd1-4a12-abd7-f1ad724a9988', 'UPDATE', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 12:54:54', 'America/Caracas', '{\"ciclo_control\":{\"old\":\"2\",\"new\":\"3\"},\"fecha_programada\":{\"old\":\"2025-12-21\",\"new\":\"2026-01-11\"},\"updated_at\":{\"old\":\"2025-11-09 12:53:06\",\"new\":\"2025-11-09 12:54:54\"}}', NULL, '96.31.87.169', '96-31-87-169.static.hvvc.us', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/revisiones-servicio/0d563d0e-cdd1-4a12-abd7-f1ad724a9988', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 12:54:54', 'America/Caracas'),
(63, 'revisiones_servicio', '0d563d0e-cdd1-4a12-abd7-f1ad724a9988', 'UPDATE', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 12:55:25', 'America/Caracas', '{\"observaciones\":{\"old\":\"fsafa\",\"new\":\"vxsfa\"},\"updated_at\":{\"old\":\"2025-11-09 12:54:54\",\"new\":\"2025-11-09 12:55:25\"}}', NULL, '66.232.126.23', '66-232-126-23.static.hvvc.us', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/revisiones-servicio/0d563d0e-cdd1-4a12-abd7-f1ad724a9988', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 12:55:25', 'America/Caracas'),
(64, 'revisiones_servicio', '0d563d0e-cdd1-4a12-abd7-f1ad724a9988', 'UPDATE', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 12:55:43', 'America/Caracas', '{\"resultado\":{\"old\":\"SOSPECHA_PREÑEZ\",\"new\":\"CONFIRMADA_PREÑEZ\"},\"observaciones\":{\"old\":\"vxsfa\",\"new\":\"\"},\"updated_at\":{\"old\":\"2025-11-09 12:55:25\",\"new\":\"2025-11-09 12:55:43\"}}', NULL, '66.232.126.23', '66-232-126-23.static.hvvc.us', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/revisiones-servicio/0d563d0e-cdd1-4a12-abd7-f1ad724a9988', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 12:55:43', 'America/Caracas'),
(65, 'periodos_servicio', '7b222c37-bc28-43be-921a-d1c9539c45ab', 'UPDATE', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 12:55:43', 'America/Caracas', '{\"estado_periodo\":{\"old\":\"\",\"new\":\"CERRADO\"}}', NULL, '66.232.126.23', '66-232-126-23.static.hvvc.us', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/revisiones-servicio/0d563d0e-cdd1-4a12-abd7-f1ad724a9988', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 12:55:43', 'America/Caracas'),
(66, 'incidencias', '6b89b7e0-5986-4bde-9ce4-058eecf40682', 'DELETE_LOGICAL', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 13:02:23', 'America/Caracas', '{\"deleted_at\": {\"old\": null, \"new\": \"2025-11-09 13:02:23\"}}', '{\"incidencia_id\": \"6b89b7e0-5986-4bde-9ce4-058eecf40682\", \"animal_id\": \"ab29db65-86d8-46c6-bc47-85a988176e4a\", \"tipo\": \"APLASTAMIENTO\", \"fecha_evento\": \"2025-11-08 21:02:00\", \"descripcion\": null, \"responsable\": null, \"area_id\": \"9927c9e7-d35a-4b1c-93b0-c078894cc9ef\", \"created_at\": \"2025-11-08 21:02:53\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\", \"updated_at\": null, \"updated_by\": null, \"deleted_at\": \"2025-11-09 13:02:23\", \"deleted_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '96.31.87.180', '96-31-87-180.static.hvvc.us', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/incidencias/6b89b7e0-5986-4bde-9ce4-058eecf40682', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 13:02:23', 'America/Caracas'),
(67, 'system_users', '202b02fa-053d-48d5-a307-b52adb5525f4', 'UPDATE', '00ff7419-9c33-488e-95fc-87d1506f6097', 'Unknown', 'Unknown', '2025-11-09 13:03:33', 'America/Caracas', '{\"updated_at\":{\"old\":\"2025-11-09 11:37:50\",\"new\":\"2025-11-09 13:03:33\"}}', NULL, '200.8.108.95', '200.8.108.95', 'Dalvik/2.1.0 (Linux; U; Android 15; 2412DPC0AG Build/AP3A.240905.015.A2)', 'Linux', 'Unknown Browser', 'sigob.net', '/ERP_SISUPP/api/system_users/login_app', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 13:03:33', 'America/Caracas'),
(68, 'incidencias', '7123afd6-589f-4bb4-9eec-b7f7c302fe01', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 13:48:54', 'America/Caracas', NULL, '{\"incidencia_id\": \"7123afd6-589f-4bb4-9eec-b7f7c302fe01\", \"animal_id\": \"s90d1b25-1f83-4e74-a730-fb94fca8f9a5\", \"tipo\": \"RINA\", \"fecha_evento\": \"2025-11-09 13:48:00\", \"descripcion\": null, \"responsable\": null, \"area_id\": \"486a43b4-565a-45d8-af5c-5efc26fb54a0\", \"created_at\": \"2025-11-09 13:48:54\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '200.8.108.95', '200.8.108.95', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/incidencias', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 13:48:54', 'America/Caracas'),
(69, 'system_users', '202b02fa-053d-48d5-a307-b52adb5525f4', 'UPDATE', '2f39b35d-1468-466f-9287-7042598e20db', 'Unknown', 'Unknown', '2025-11-09 13:52:17', 'America/Caracas', '{\"updated_at\":{\"old\":\"2025-11-09 13:03:33\",\"new\":\"2025-11-09 13:52:17\"}}', NULL, '200.8.108.95', '200.8.108.95', 'Dalvik/2.1.0 (Linux; U; Android 15; 2412DPC0AG Build/AP3A.240905.015.A2)', 'Linux', 'Unknown Browser', 'sigob.net', '/ERP_SISUPP/api/system_users/login_app', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 13:52:17', 'America/Caracas'),
(70, 'system_users', 'd7518474-2d2f-4634-823f-71936565c110', 'UPDATE', '7b6373ab-be11-452e-9e7a-d1086151889c', 'Unknown', 'Unknown', '2025-11-09 13:52:44', 'America/Caracas', '{\"updated_at\":{\"old\":\"2025-10-05 15:46:18\",\"new\":\"2025-11-09 13:52:44\"}}', NULL, '190.199.186.72', '190-199-186-72.pod-00-p69.cantv.net', 'Dalvik/2.1.0 (Linux; U; Android 14; TECNO KL5 Build/UP1A.231005.007)', 'Linux', 'Unknown Browser', 'sigob.net', '/ERP_SISUPP/api/system_users/login_app', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 13:52:44', 'America/Caracas'),
(71, 'incidencias', '7123afd6-589f-4bb4-9eec-b7f7c302fe01', 'DELETE_LOGICAL', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 13:52:51', 'America/Caracas', '{\"deleted_at\": {\"old\": null, \"new\": \"2025-11-09 13:52:51\"}}', '{\"incidencia_id\": \"7123afd6-589f-4bb4-9eec-b7f7c302fe01\", \"animal_id\": \"s90d1b25-1f83-4e74-a730-fb94fca8f9a5\", \"tipo\": \"RINA\", \"fecha_evento\": \"2025-11-09 13:48:00\", \"descripcion\": null, \"responsable\": null, \"area_id\": \"486a43b4-565a-45d8-af5c-5efc26fb54a0\", \"created_at\": \"2025-11-09 13:48:54\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\", \"updated_at\": null, \"updated_by\": null, \"deleted_at\": \"2025-11-09 13:52:51\", \"deleted_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '200.8.108.95', '200.8.108.95', 'Mozilla/5.0 (Linux; Android 15; 2412DPC0AG Build/AP3A.240905.015.A2; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/141.0.7390.122 Mobile Safari/537.36', 'Linux', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/incidencias/7123afd6-589f-4bb4-9eec-b7f7c302fe01', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 13:52:51', 'America/Caracas'),
(72, 'system_users', '202b02fa-053d-48d5-a307-b52adb5525f4', 'UPDATE', '20f0fed0-b2a1-4a8f-bb51-cf410534fc39', 'Unknown', 'Unknown', '2025-11-09 14:03:09', 'America/Caracas', '{\"updated_at\":{\"old\":\"2025-11-09 13:52:17\",\"new\":\"2025-11-09 14:03:09\"}}', NULL, '200.8.108.95', '200.8.108.95', 'Dalvik/2.1.0 (Linux; U; Android 15; 2412DPC0AG Build/AP3A.240905.015.A2)', 'Linux', 'Unknown Browser', 'sigob.net', '/ERP_SISUPP/api/system_users/login_app', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 14:03:09', 'America/Caracas'),
(73, 'incidencias', 'b675454b-dba6-4d90-863b-bfc83cba3af2', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 14:04:12', 'America/Caracas', NULL, '{\"incidencia_id\": \"b675454b-dba6-4d90-863b-bfc83cba3af2\", \"animal_id\": \"ab29db65-86d8-46c6-bc47-85a988176e4a\", \"tipo\": \"RINA\", \"fecha_evento\": \"2025-11-09 14:04:00\", \"descripcion\": null, \"responsable\": null, \"area_id\": \"9927c9e7-d35a-4b1c-93b0-c078894cc9ef\", \"created_at\": \"2025-11-09 14:04:12\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '200.8.108.95', '200.8.108.95', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/incidencias', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 14:04:12', 'America/Caracas'),
(74, 'system_users', '202b02fa-053d-48d5-a307-b52adb5525f4', 'UPDATE', '8508387c-e3f2-479f-b015-5389430e81b9', 'Unknown', 'Unknown', '2025-11-09 20:34:47', 'America/Caracas', '{\"updated_at\":{\"old\":\"2025-11-09 14:03:09\",\"new\":\"2025-11-09 20:34:47\"}}', NULL, '200.8.108.95', '200.8.108.95', 'Dalvik/2.1.0 (Linux; U; Android 15; 2412DPC0AG Build/AP3A.240905.015.A2)', 'Linux', 'Unknown Browser', 'sigob.net', '/ERP_SISUPP/api/system_users/login_app', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 20:34:46', 'America/Caracas'),
(75, 'incidencias', 'ad09d518-2565-4a4c-a0f0-294be309f6c0', 'DELETE_LOGICAL', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-09 20:35:27', 'America/Caracas', '{\"deleted_at\": {\"old\": null, \"new\": \"2025-11-09 20:35:27\"}}', '{\"incidencia_id\": \"ad09d518-2565-4a4c-a0f0-294be309f6c0\", \"animal_id\": \"l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0\", \"tipo\": \"APLASTAMIENTO\", \"fecha_evento\": \"2025-11-09 00:00:00\", \"descripcion\": \"Aplastamiento de 1 lechón(es). Baja registrada.\", \"responsable\": \"sistema\", \"area_id\": null, \"created_at\": \"2025-11-09 10:56:50\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\", \"updated_at\": null, \"updated_by\": null, \"deleted_at\": \"2025-11-09 20:35:27\", \"deleted_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '200.8.108.95', '200.8.108.95', 'Mozilla/5.0 (Linux; Android 15; 2412DPC0AG Build/AP3A.240905.015.A2; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/141.0.7390.122 Mobile Safari/537.36', 'Linux', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/incidencias/ad09d518-2565-4a4c-a0f0-294be309f6c0', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-09 20:35:27', 'America/Caracas'),
(76, 'system_users', 'd7518474-2d2f-4634-823f-71936565c110', 'UPDATE', 'dcb86ee9-d8e5-4cfb-b4e6-2c4254bb7c47', 'Unknown', 'Unknown', '2025-11-10 10:03:35', 'America/Caracas', '{\"updated_at\":{\"old\":\"2025-11-09 13:52:44\",\"new\":\"2025-11-10 10:03:35\"}}', NULL, '181.208.26.134', '181.208.26.134', 'Dalvik/2.1.0 (Linux; U; Android 16; SM-A566E Build/BP2A.250605.031.A3)', 'Linux', 'Unknown Browser', 'sigob.net', '/ERP_SISUPP/api/system_users/login_app', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-10 10:03:35', 'America/Caracas'),
(77, 'system_users', 'd7518474-2d2f-4634-823f-71936565c110', 'UPDATE', '67fbbe24-6ab9-4cbb-9aa0-cd716d09e27a', 'Unknown', 'Unknown', '2025-11-10 11:20:19', 'America/Caracas', '{\"dispositivo_token\":{\"old\":\"eUb8e-QET3i1y_aYOo0JXl:APA91bGAKEUCaiGJ0YohEgE8CUs3lscu_V9Vnt6bdquop6bgtJ2ihOITRP_JI7qgRVYZRdMbkGMWe6P8kFnwVtnEZDVhKVIueOMB8udxReAWFsoisSu0Rh8\",\"new\":\"cOZy-ShDTyy3z4ZsSrvKQS:APA91bEPuArUpk09cUda0aXiZhIJT4yRLFw1HzldsJr1VY3RZWISoLKgOcUbyBAVidKv5WwN_jGmMaulQy-wdoNYz7zMjDWZALS6kdXXwaq3YM7XU7kcxB8\"},\"updated_at\":{\"old\":\"2025-11-10 10:03:35\",\"new\":\"2025-11-10 11:20:19\"}}', NULL, '190.75.94.7', '190.75-94-7.pod-00-p68.cantv.net', 'Dalvik/2.1.0 (Linux; U; Android 14; TECNO KL5 Build/UP1A.231005.007)', 'Linux', 'Unknown Browser', 'sigob.net', '/ERP_SISUPP/api/system_users/login_app', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-10 11:20:19', 'America/Caracas');
INSERT INTO `audit_log` (`audit_id`, `table_name`, `record_id`, `action_type`, `action_by`, `full_name`, `user_type`, `action_timestamp`, `action_timezone`, `changes`, `full_row`, `client_ip`, `client_hostname`, `user_agent`, `client_os`, `client_browser`, `domain_name`, `request_uri`, `server_hostname`, `client_country`, `client_region`, `client_city`, `client_zipcode`, `client_coordinates`, `geo_ip_timestamp`, `geo_ip_timezone`) VALUES
(78, 'system_users', 'd7518474-2d2f-4634-823f-71936565c110', 'UPDATE', '2e17c0b7-5fed-4900-bbba-6a4972a62586', 'Unknown', 'Unknown', '2025-11-10 13:54:09', 'America/Caracas', '{\"dispositivo_token\":{\"old\":\"cOZy-ShDTyy3z4ZsSrvKQS:APA91bEPuArUpk09cUda0aXiZhIJT4yRLFw1HzldsJr1VY3RZWISoLKgOcUbyBAVidKv5WwN_jGmMaulQy-wdoNYz7zMjDWZALS6kdXXwaq3YM7XU7kcxB8\",\"new\":\"eUb8e-QET3i1y_aYOo0JXl:APA91bGAKEUCaiGJ0YohEgE8CUs3lscu_V9Vnt6bdquop6bgtJ2ihOITRP_JI7qgRVYZRdMbkGMWe6P8kFnwVtnEZDVhKVIueOMB8udxReAWFsoisSu0Rh8\"},\"updated_at\":{\"old\":\"2025-11-10 11:20:19\",\"new\":\"2025-11-10 13:54:09\"}}', NULL, '185.132.178.95', '185-132-178-95.hosted-by-worldstream.net', 'Dalvik/2.1.0 (Linux; U; Android 16; SM-A566E Build/BP2A.250605.031.A3)', 'Linux', 'Unknown Browser', 'sigob.net', '/ERP_SISUPP/api/system_users/login_app', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-10 13:54:08', 'America/Caracas'),
(79, 'system_users', '202b02fa-053d-48d5-a307-b52adb5525f4', 'UPDATE', 'ad99ae46-3341-4696-8e69-1b4d8901a2ca', 'Unknown', 'Unknown', '2025-11-10 14:19:36', 'America/Caracas', '{\"dispositivo_token\":{\"old\":\"euzz2-c7TC6Bo6abM4Faj8:APA91bHrwuejBqN-bLbsQwQYu_oQlCQWX19QTsXE1b4wwXXqtRpapQq-zv9ih3Ep9iK29Tj8GHqpXI7bcyStykATaLt2BHAEMqvSub5HRCQkoim9NVRa3A8\",\"new\":\"e-lzH5uiT76dVxVrdiWZXH:APA91bGpXNX4l5SYD6vVqKUnuBySbTEpBo8YQExiB7mu9bO1lANBO9hjF6AZyFdg9zj3x1yEUSHabFBKNqBbP_HZSCUX3QbWR7oC5ptzRuHHBXxovpEKuy8\"},\"updated_at\":{\"old\":\"2025-11-09 20:34:47\",\"new\":\"2025-11-10 14:19:36\"}}', NULL, '200.8.108.95', '200.8.108.95', 'Dalvik/2.1.0 (Linux; U; Android 15; 2412DPC0AG Build/AP3A.240905.015.A2)', 'Linux', 'Unknown Browser', 'sigob.net', '/ERP_SISUPP/api/system_users/login_app', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-10 14:19:36', 'America/Caracas'),
(80, 'incidencias', '805af77c-ff5a-4736-9688-6e233ca217d5', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-10 14:56:20', 'America/Caracas', NULL, '{\"incidencia_id\": \"805af77c-ff5a-4736-9688-6e233ca217d5\", \"animal_id\": \"s90d1b25-1f83-4e74-a730-fb94fca8f9a5\", \"tipo\": \"RINA\", \"fecha_evento\": \"2025-11-10 14:54:00\", \"descripcion\": \"fsa\", \"responsable\": \"fsa\", \"area_id\": \"9927c9e7-d35a-4b1c-93b0-c078894cc9ef\", \"created_at\": \"2025-11-10 14:56:20\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '66.232.126.21', '66-232-126-21.static.hvvc.us', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36', 'Linux', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/incidencias', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-10 14:56:20', 'America/Caracas'),
(81, 'incidencias', '805af77c-ff5a-4736-9688-6e233ca217d5', 'DELETE_LOGICAL', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-10 14:56:50', 'America/Caracas', '{\"deleted_at\": {\"old\": null, \"new\": \"2025-11-10 14:56:50\"}}', '{\"incidencia_id\": \"805af77c-ff5a-4736-9688-6e233ca217d5\", \"animal_id\": \"s90d1b25-1f83-4e74-a730-fb94fca8f9a5\", \"tipo\": \"RINA\", \"fecha_evento\": \"2025-11-10 14:54:00\", \"descripcion\": \"fsa\", \"responsable\": \"fsa\", \"area_id\": \"9927c9e7-d35a-4b1c-93b0-c078894cc9ef\", \"created_at\": \"2025-11-10 14:56:20\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\", \"updated_at\": null, \"updated_by\": null, \"deleted_at\": \"2025-11-10 14:56:50\", \"deleted_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '200.8.108.95', '200.8.108.95', 'Mozilla/5.0 (Linux; Android 15; 2412DPC0AG Build/AP3A.240905.015.A2; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/141.0.7390.122 Mobile Safari/537.36', 'Linux', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/incidencias/805af77c-ff5a-4736-9688-6e233ca217d5', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-10 14:56:50', 'America/Caracas'),
(82, 'incidencias', 'ae805823-cc01-46e4-87f2-5e9d3e523b23', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-10 14:58:05', 'America/Caracas', NULL, '{\"incidencia_id\": \"ae805823-cc01-46e4-87f2-5e9d3e523b23\", \"animal_id\": \"s90d1b25-1f83-4e74-a730-fb94fca8f9a5\", \"tipo\": \"RINA\", \"fecha_evento\": \"2025-11-10 14:57:00\", \"descripcion\": \"fsa\", \"responsable\": \"fsa\", \"area_id\": \"9927c9e7-d35a-4b1c-93b0-c078894cc9ef\", \"created_at\": \"2025-11-10 14:58:05\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '66.232.126.13', '66-232-126-13.static.hvvc.us', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36', 'Linux', 'Google Chrome', 'sigob.net', '/ERP_SISUPP/api/incidencias', 'max.servidoro.com', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-10 14:58:05', 'America/Caracas'),
(83, 'menu', '920a038d-e341-4c61-9915-d35fb41d1a6b', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-12 13:42:13', 'SYSTEM', '{\"categoria\":{\"old\":\"\",\"new\":\"infraestructura\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'IT-CB01', '', '', '', '', '', '2025-11-12 13:42:13', 'SYSTEM'),
(84, 'menu', '920a038d-e341-4c61-9915-d35fb41d1a6b', 'UPDATE', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-12 13:42:57', 'America/Caracas', '{\"url\":{\"old\":\"fincas\",\"new\":\"registro de infraestructura\"},\"updated_at\":{\"old\":\"2025-10-12 21:31:16\",\"new\":\"2025-11-12 13:42:57\"},\"updated_by\":{\"old\":\"d7518474-2d2f-4634-823f-71936565c110\",\"new\":\"202b02fa-053d-48d5-a307-b52adb5525f4\"}}', NULL, '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/menus/920a038d-e341-4c61-9915-d35fb41d1a6b', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-12 13:42:57', 'America/Caracas'),
(85, 'menu', '920a038d-e341-4c61-9915-d35fb41d1a6b', 'UPDATE', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-12 13:43:21', 'America/Caracas', '{\"nombre\":{\"old\":\"Fincas\",\"new\":\"Registro de Infraestructura\"},\"url\":{\"old\":\"registro de infraestructura\",\"new\":\"infraestructura\"},\"updated_at\":{\"old\":\"2025-11-12 13:42:57\",\"new\":\"2025-11-12 13:43:21\"}}', NULL, '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/menus/920a038d-e341-4c61-9915-d35fb41d1a6b', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-12 13:43:21', 'America/Caracas'),
(86, 'menu', '4aeb6638-fb70-40c2-bf53-8b73faae4389', 'DELETE_LOGICAL', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-12 13:44:59', 'America/Caracas', '{\"deleted_at\": {\"old\": null, \"new\": \"2025-11-12 13:44:59\"}}', '{\"menu_id\": \"4aeb6638-fb70-40c2-bf53-8b73faae4389\", \"categoria\": \"reporte_dano\", \"nombre\": \"Reportes (Administración\", \"url\": \"reportes-administracion\", \"icono\": \"mdi mdi-shield-check\", \"user_level\": 1, \"orden\": 0, \"created_at\": \"2025-11-03 09:42:58\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\", \"updated_at\": \"2025-11-03 09:54:39\", \"updated_by\": \"d7518474-2d2f-4634-823f-71936565c110\", \"deleted_at\": \"2025-11-12 13:44:59\", \"deleted_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/menus/4aeb6638-fb70-40c2-bf53-8b73faae4389', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-12 13:44:59', 'America/Caracas'),
(87, 'menu', 'bc2f3fd9-46bd-44dc-baac-b057feef025c', 'DELETE_LOGICAL', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-12 13:45:02', 'America/Caracas', '{\"deleted_at\": {\"old\": null, \"new\": \"2025-11-12 13:45:02\"}}', '{\"menu_id\": \"bc2f3fd9-46bd-44dc-baac-b057feef025c\", \"categoria\": \"reporte_dano\", \"nombre\": \"Reportes (Usuario)\", \"url\": \"reportes-usuario\", \"icono\": \"mdi mdi-file-send\", \"user_level\": 1, \"orden\": 0, \"created_at\": \"2025-11-03 09:44:00\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\", \"updated_at\": null, \"updated_by\": null, \"deleted_at\": \"2025-11-12 13:45:02\", \"deleted_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/menus/bc2f3fd9-46bd-44dc-baac-b057feef025c', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-12 13:45:02', 'America/Caracas'),
(88, 'menu', '22f9bbb0-4518-4079-b9e9-1b901f934288', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-12 13:45:25', 'America/Caracas', NULL, '{\"menu_id\": \"22f9bbb0-4518-4079-b9e9-1b901f934288\", \"categoria\": \"infraestructura\", \"nombre\": \"Estado de infraestructura\", \"url\": \"reportes-administracion\", \"icono\": \"mdi mdi-shield-check\", \"user_level\": 1, \"orden\": 0, \"created_at\": \"2025-11-12 13:45:25\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/menus', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-12 13:45:25', 'America/Caracas'),
(89, 'menu', 'd7b72d0b-d13e-4599-b805-539731cf5087', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-12 13:45:54', 'America/Caracas', NULL, '{\"menu_id\": \"d7b72d0b-d13e-4599-b805-539731cf5087\", \"categoria\": \"infraestructura\", \"nombre\": \"Reporte de daños\", \"url\": \"reportes-usuario\", \"icono\": \"mdi mdi-file-send\", \"user_level\": 1, \"orden\": 0, \"created_at\": \"2025-11-12 13:45:54\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/menus', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-12 13:45:54', 'America/Caracas'),
(90, 'menu', '920a038d-e341-4c61-9915-d35fb41d1a6b', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-12 13:45:58', 'SYSTEM', '{\"orden\":{\"old\":\"3\",\"new\":\"0\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'IT-CB01', '', '', '', '', '', '2025-11-12 13:45:58', 'SYSTEM'),
(91, 'menu', '22f9bbb0-4518-4079-b9e9-1b901f934288', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-12 13:45:58', 'SYSTEM', '{\"orden\":{\"old\":\"0\",\"new\":\"1\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'IT-CB01', '', '', '', '', '', '2025-11-12 13:45:58', 'SYSTEM'),
(92, 'menu', 'd7b72d0b-d13e-4599-b805-539731cf5087', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-12 13:45:58', 'SYSTEM', '{\"orden\":{\"old\":\"0\",\"new\":\"2\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'IT-CB01', '', '', '', '', '', '2025-11-12 13:45:58', 'SYSTEM'),
(93, 'menu', 'd7b72d0b-d13e-4599-b805-539731cf5087', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-12 13:46:00', 'SYSTEM', '{\"orden\":{\"old\":\"2\",\"new\":\"1\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'IT-CB01', '', '', '', '', '', '2025-11-12 13:46:00', 'SYSTEM'),
(94, 'menu', '22f9bbb0-4518-4079-b9e9-1b901f934288', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-12 13:46:00', 'SYSTEM', '{\"orden\":{\"old\":\"1\",\"new\":\"2\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'IT-CB01', '', '', '', '', '', '2025-11-12 13:46:00', 'SYSTEM'),
(95, 'menu', '0aa89a19-946d-4993-90b1-84d352ad77a1', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-12 13:49:06', 'America/Caracas', NULL, '{\"menu_id\": \"0aa89a19-946d-4993-90b1-84d352ad77a1\", \"categoria\": \"animales\", \"nombre\": \"Gestación\", \"url\": \"animales/gestación\", \"icono\": \"mdi mdi-dna\", \"user_level\": 1, \"orden\": 0, \"created_at\": \"2025-11-12 13:49:06\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/menus', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-12 13:49:06', 'America/Caracas'),
(96, 'menu', '50e9bd96-c2b4-4db8-bfe2-53ff25a7e8e7', 'DELETE_LOGICAL', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-12 13:49:21', 'America/Caracas', '{\"deleted_at\": {\"old\": null, \"new\": \"2025-11-12 13:49:21\"}}', '{\"menu_id\": \"50e9bd96-c2b4-4db8-bfe2-53ff25a7e8e7\", \"categoria\": \"montas\", \"nombre\": \"Gestaciones\", \"url\": \"animales/gestacion\", \"icono\": \"mdi mdi-dna\", \"user_level\": 1, \"orden\": 0, \"created_at\": \"2025-11-03 09:36:55\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\", \"updated_at\": \"2025-11-03 09:53:23\", \"updated_by\": \"d7518474-2d2f-4634-823f-71936565c110\", \"deleted_at\": \"2025-11-12 13:49:21\", \"deleted_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/menus/50e9bd96-c2b4-4db8-bfe2-53ff25a7e8e7', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-12 13:49:21', 'America/Caracas'),
(97, 'menu', 'e1927925-5257-40ca-895b-132154024964', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-12 14:02:12', 'America/Caracas', NULL, '{\"menu_id\": \"e1927925-5257-40ca-895b-132154024964\", \"categoria\": \"\", \"nombre\": \"test\", \"url\": \"test\", \"icono\": \"\", \"user_level\": 1, \"orden\": 0, \"created_at\": \"2025-11-12 14:02:12\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/menus', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-12 14:02:12', 'America/Caracas'),
(98, 'menu', 'fa31f24d-1c58-484c-9e23-33c7afc991e6', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-12 14:03:18', 'America/Caracas', NULL, '{\"menu_id\": \"fa31f24d-1c58-484c-9e23-33c7afc991e6\", \"categoria\": \"administracion\", \"nombre\": \"test\", \"url\": \"test\", \"icono\": \"\", \"user_level\": 1, \"orden\": 0, \"created_at\": \"2025-11-12 14:03:18\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/menus', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-12 14:03:18', 'America/Caracas'),
(99, 'menu', 'e1927925-5257-40ca-895b-132154024964', 'DELETE_PHYSICAL', '0', 'phpMyAdmin', 'system', '2025-11-12 14:03:27', 'SYSTEM', NULL, '{\"menu_id\": \"e1927925-5257-40ca-895b-132154024964\", \"categoria\": \"\", \"nombre\": \"test\", \"url\": \"test\", \"icono\": \"\", \"user_level\": 1, \"orden\": 0, \"created_at\": \"2025-11-12 14:02:12\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\", \"updated_at\": null, \"updated_by\": null, \"deleted_at\": null, \"deleted_by\": null}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'IT-CB01', '', '', '', '', '', '2025-11-12 14:03:27', 'SYSTEM'),
(100, 'animal_salud', '0303ed46-c8b3-4f44-85d2-c100b116801e', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-14 11:18:35', 'SYSTEM', NULL, '{\"animal_salud_id\": \"0303ed46-c8b3-4f44-85d2-c100b116801e\", \"animal_id\": \"l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0\", \"fecha_evento\": \"2025-11-14\", \"tipo_evento\": \"\", \"diagnostico\": \"Gripe porcina\", \"severidad\": null, \"tratamiento\": null, \"medicamento\": null, \"dosis\": null, \"via_administracion\": null, \"costo\": null, \"estado\": \"ABIERTO\", \"proxima_revision\": \"2025-11-14\", \"responsable\": null, \"observaciones\": \"No se que poner aqui\", \"created_at\": \"2025-11-14 11:18:35\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-14 11:18:35', 'SYSTEM'),
(101, 'animal_salud', '80a8d098-9fc2-4376-8b63-5802310cd23b', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-14 11:21:19', 'SYSTEM', NULL, '{\"animal_salud_id\": \"80a8d098-9fc2-4376-8b63-5802310cd23b\", \"animal_id\": \"s90d1b25-1f83-4e74-a730-fb94fca8f9a5\", \"fecha_evento\": \"2025-11-14\", \"tipo_evento\": \"VACUNACION\", \"diagnostico\": null, \"severidad\": null, \"tratamiento\": null, \"medicamento\": \"fsa\", \"dosis\": \"2\", \"via_administracion\": null, \"costo\": null, \"estado\": \"ABIERTO\", \"proxima_revision\": null, \"responsable\": null, \"observaciones\": \"fafafa\", \"created_at\": \"2025-11-14 11:21:19\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-14 11:21:19', 'SYSTEM'),
(102, 'animal_salud', '14c2d153-e5d5-46e6-bf33-d3990d24cda0', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-14 11:21:19', 'SYSTEM', NULL, '{\"animal_salud_id\": \"14c2d153-e5d5-46e6-bf33-d3990d24cda0\", \"animal_id\": \"ab29db65-86d8-46c6-bc47-85a988176e4a\", \"fecha_evento\": \"2025-11-14\", \"tipo_evento\": \"VACUNACION\", \"diagnostico\": null, \"severidad\": null, \"tratamiento\": null, \"medicamento\": \"fsa\", \"dosis\": \"2\", \"via_administracion\": null, \"costo\": null, \"estado\": \"ABIERTO\", \"proxima_revision\": null, \"responsable\": null, \"observaciones\": \"fafafa\", \"created_at\": \"2025-11-14 11:21:19\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-14 11:21:19', 'SYSTEM'),
(103, 'animal_salud', 'f29e0fb3-1f7c-4a08-8946-fe6778f1c3b0', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-14 11:21:19', 'SYSTEM', NULL, '{\"animal_salud_id\": \"f29e0fb3-1f7c-4a08-8946-fe6778f1c3b0\", \"animal_id\": \"m34ef0bb-3a45-4cb8-9a51-c5ab91874aab\", \"fecha_evento\": \"2025-11-14\", \"tipo_evento\": \"VACUNACION\", \"diagnostico\": null, \"severidad\": null, \"tratamiento\": null, \"medicamento\": \"fsa\", \"dosis\": \"2\", \"via_administracion\": null, \"costo\": null, \"estado\": \"ABIERTO\", \"proxima_revision\": null, \"responsable\": null, \"observaciones\": \"fafafa\", \"created_at\": \"2025-11-14 11:21:19\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-14 11:21:19', 'SYSTEM'),
(104, 'animal_salud', '56f0f5e9-a2ac-47cc-acec-993e53278fc3', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-14 11:21:19', 'SYSTEM', NULL, '{\"animal_salud_id\": \"56f0f5e9-a2ac-47cc-acec-993e53278fc3\", \"animal_id\": \"o56c983a-5cf7-4e0b-970a-5fa81dfcb778\", \"fecha_evento\": \"2025-11-14\", \"tipo_evento\": \"VACUNACION\", \"diagnostico\": null, \"severidad\": null, \"tratamiento\": null, \"medicamento\": \"fsa\", \"dosis\": \"2\", \"via_administracion\": null, \"costo\": null, \"estado\": \"ABIERTO\", \"proxima_revision\": null, \"responsable\": null, \"observaciones\": \"fafafa\", \"created_at\": \"2025-11-14 11:21:19\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-14 11:21:19', 'SYSTEM'),
(105, 'animal_salud', 'ac5e03e6-02d5-49e5-a88a-fe98a4c1b069', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-14 11:21:19', 'SYSTEM', NULL, '{\"animal_salud_id\": \"ac5e03e6-02d5-49e5-a88a-fe98a4c1b069\", \"animal_id\": \"r89b4e6a-b25d-4fcd-952e-f3b36cb2786f\", \"fecha_evento\": \"2025-11-14\", \"tipo_evento\": \"VACUNACION\", \"diagnostico\": null, \"severidad\": null, \"tratamiento\": null, \"medicamento\": \"fsa\", \"dosis\": \"2\", \"via_administracion\": null, \"costo\": null, \"estado\": \"ABIERTO\", \"proxima_revision\": null, \"responsable\": null, \"observaciones\": \"fafafa\", \"created_at\": \"2025-11-14 11:21:19\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-14 11:21:19', 'SYSTEM'),
(106, 'animal_salud', '3a6a9f62-ff1a-45cd-ad98-a42b8ae9fc67', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-14 11:21:19', 'SYSTEM', NULL, '{\"animal_salud_id\": \"3a6a9f62-ff1a-45cd-ad98-a42b8ae9fc67\", \"animal_id\": \"b2a45ee3-9b48-4d12-9023-f86b2116a4e9\", \"fecha_evento\": \"2025-11-14\", \"tipo_evento\": \"VACUNACION\", \"diagnostico\": null, \"severidad\": null, \"tratamiento\": null, \"medicamento\": \"fsa\", \"dosis\": \"2\", \"via_administracion\": null, \"costo\": null, \"estado\": \"ABIERTO\", \"proxima_revision\": null, \"responsable\": null, \"observaciones\": \"fafafa\", \"created_at\": \"2025-11-14 11:21:19\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'max.servidoro.com', '', '', '', '', '', '2025-11-14 11:21:19', 'SYSTEM'),
(107, 'animal_salud', '368b6f4b-e66a-4b6c-abf3-41e35a95bd4e', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-14 11:26:12', 'America/Caracas', NULL, '{\"animal_salud_id\": \"368b6f4b-e66a-4b6c-abf3-41e35a95bd4e\", \"animal_id\": \"l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0\", \"fecha_evento\": \"2025-11-14\", \"tipo_evento\": \"VACUNACION\", \"diagnostico\": null, \"severidad\": null, \"tratamiento\": null, \"medicamento\": \"fsa\", \"dosis\": \"2\", \"via_administracion\": null, \"costo\": null, \"estado\": \"ABIERTO\", \"proxima_revision\": null, \"responsable\": null, \"observaciones\": \"fsafafa\", \"created_at\": \"2025-11-14 11:26:12\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '::1', 'DESKTOP-BRTU0R4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/acontecimientos', 'DESKTOP-BRTU0R4', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-14 11:26:12', 'America/Caracas'),
(108, 'animal_salud', 'a36deb04-c562-4d9b-926e-dc3134551f3b', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-14 11:27:23', 'America/Caracas', NULL, '{\"animal_salud_id\": \"a36deb04-c562-4d9b-926e-dc3134551f3b\", \"animal_id\": \"l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0\", \"fecha_evento\": \"2025-11-14\", \"tipo_evento\": \"VACUNACION\", \"diagnostico\": null, \"severidad\": null, \"tratamiento\": null, \"medicamento\": \"fsa\", \"dosis\": \"2\", \"via_administracion\": null, \"costo\": null, \"estado\": \"ABIERTO\", \"proxima_revision\": null, \"responsable\": null, \"observaciones\": \"fsafafa\", \"created_at\": \"2025-11-14 11:27:23\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '::1', 'DESKTOP-BRTU0R4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/acontecimientos', 'DESKTOP-BRTU0R4', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-14 11:27:23', 'America/Caracas'),
(109, 'animal_salud', '66be63cd-8467-4f35-b244-53108d3349f7', 'INSERT', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-14 11:30:08', 'America/Caracas', NULL, '{\"animal_salud_id\": \"66be63cd-8467-4f35-b244-53108d3349f7\", \"animal_id\": \"l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0\", \"fecha_evento\": \"2025-11-14\", \"tipo_evento\": \"\", \"diagnostico\": \"Gripe porcina\", \"severidad\": null, \"tratamiento\": null, \"medicamento\": null, \"dosis\": null, \"via_administracion\": null, \"costo\": null, \"estado\": \"ABIERTO\", \"proxima_revision\": \"2025-11-16\", \"responsable\": null, \"observaciones\": \"fsafa\", \"created_at\": \"2025-11-14 11:30:08\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\"}', '::1', 'DESKTOP-BRTU0R4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/acontecimientos', 'DESKTOP-BRTU0R4', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-14 11:30:08', 'America/Caracas'),
(110, 'system_users', 'd7518474-2d2f-4634-823f-71936565c110', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-14 11:31:33', 'SYSTEM', '{\"dispositivo_token\":{\"old\":\"eUb8e-QET3i1y_aYOo0JXl:APA91bGAKEUCaiGJ0YohEgE8CUs3lscu_V9Vnt6bdquop6bgtJ2ihOITRP_JI7qgRVYZRdMbkGMWe6P8kFnwVtnEZDVhKVIueOMB8udxReAWFsoisSu0Rh8\",\"new\":\"cOZy-ShDTyy3z4ZsSrvKQS:APA91bEPuArUpk09cUda0aXiZhIJT4yRLFw1HzldsJr1VY3RZWISoLKgOcUbyBAVidKv5WwN_jGmMaulQy-wdoNYz7zMjDWZALS6kdXXwaq3YM7XU7kcxB8\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'DESKTOP-BRTU0R4', '', '', '', '', '', '2025-11-14 11:31:33', 'SYSTEM'),
(111, 'animal_salud', 'f09b0f02-7ed2-4ff2-b3b3-3bd1da1cec6d', 'INSERT', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-14 11:31:37', 'America/Caracas', NULL, '{\"animal_salud_id\": \"f09b0f02-7ed2-4ff2-b3b3-3bd1da1cec6d\", \"animal_id\": \"l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0\", \"fecha_evento\": \"2025-11-14\", \"tipo_evento\": \"\", \"diagnostico\": \"Gripe porcina\", \"severidad\": null, \"tratamiento\": null, \"medicamento\": null, \"dosis\": null, \"via_administracion\": null, \"costo\": null, \"estado\": \"ABIERTO\", \"proxima_revision\": \"2025-11-16\", \"responsable\": null, \"observaciones\": \"fsafa\", \"created_at\": \"2025-11-14 11:31:37\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\"}', '::1', 'DESKTOP-BRTU0R4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/acontecimientos', 'DESKTOP-BRTU0R4', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-14 11:31:37', 'America/Caracas'),
(112, 'animal_pesos', '632ffb84-d3e1-4367-a2b2-abd522982bbb', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-17 10:44:44', 'America/Caracas', NULL, '{\"animal_peso_id\": \"632ffb84-d3e1-4367-a2b2-abd522982bbb\", \"animal_id\": \"ab29db65-86d8-46c6-bc47-85a988176e4a\", \"fecha_peso\": \"2025-11-17\", \"peso_kg\": 20.000, \"metodo\": \"Balanza\", \"observaciones\": \"fsafa\", \"created_at\": \"2025-11-17 10:44:44\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '::1', 'DESKTOP-BRTU0R4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/animal_pesos', 'DESKTOP-BRTU0R4', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-17 10:44:44', 'America/Caracas'),
(113, 'animal_pesos', '6508707d-c913-46dd-92b6-587c0c7c5394', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-17 10:45:14', 'America/Caracas', NULL, '{\"animal_peso_id\": \"6508707d-c913-46dd-92b6-587c0c7c5394\", \"animal_id\": \"s90d1b25-1f83-4e74-a730-fb94fca8f9a5\", \"fecha_peso\": \"2025-11-17\", \"peso_kg\": 25.000, \"metodo\": \"Balanza\", \"observaciones\": \"fsafa\", \"created_at\": \"2025-11-17 10:45:14\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '::1', 'DESKTOP-BRTU0R4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/animal_pesos', 'DESKTOP-BRTU0R4', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-17 10:45:14', 'America/Caracas'),
(114, 'animal_pesos', '03c6676b-5788-4d92-9220-e8480acee8de', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-17 10:45:29', 'America/Caracas', NULL, '{\"animal_peso_id\": \"03c6676b-5788-4d92-9220-e8480acee8de\", \"animal_id\": \"k12c3441-b7f6-4af3-8a9e-43df2b28aee7\", \"fecha_peso\": \"2025-11-17\", \"peso_kg\": 30.000, \"metodo\": \"Balanza\", \"observaciones\": \"fsafa\", \"created_at\": \"2025-11-17 10:45:29\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '::1', 'DESKTOP-BRTU0R4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/animal_pesos', 'DESKTOP-BRTU0R4', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-17 10:45:29', 'America/Caracas'),
(115, 'animal_pesos', 'f815cc9f-3a11-430d-9c8d-9676c7e1332a', 'INSERT', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-17 10:46:03', 'America/Caracas', NULL, '{\"animal_peso_id\": \"f815cc9f-3a11-430d-9c8d-9676c7e1332a\", \"animal_id\": \"m34ef0bb-3a45-4cb8-9a51-c5ab91874aab\", \"fecha_peso\": \"2025-11-17\", \"peso_kg\": 20.000, \"metodo\": \"Balanza\", \"observaciones\": \"fsasfa\", \"created_at\": \"2025-11-17 10:46:03\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '::1', 'DESKTOP-BRTU0R4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/animal_pesos', 'DESKTOP-BRTU0R4', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-17 10:46:03', 'America/Caracas'),
(116, 'periodos_servicio', '4e7cb250-c176-4ad0-b13e-af0544df7d89', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-17 10:47:17', 'SYSTEM', NULL, '{\"periodo_id\": \"4e7cb250-c176-4ad0-b13e-af0544df7d89\", \"hembra_id\": \"s90d1b25-1f83-4e74-a730-fb94fca8f9a5\", \"verraco_id\": \"ab29db65-86d8-46c6-bc47-85a988176e4a\", \"fecha_inicio\": \"2025-11-01\", \"hora_servicio\": \"10:47:00\", \"frecuencia_servicios\": \"diaria\", \"numero_servicios\": 5, \"observaciones\": \"fassfa\", \"estado_periodo\": \"ABIERTO\", \"created_at\": \"2025-11-17 15:47:17\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'DESKTOP-BRTU0R4', '', '', '', '', '', '2025-11-17 10:47:17', 'SYSTEM'),
(117, 'servicios', 'd76f564a-f9dd-49eb-89f7-e2c47fe1ab08', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-17 10:47:17', 'SYSTEM', NULL, '{\"monta_id\": \"d76f564a-f9dd-49eb-89f7-e2c47fe1ab08\", \"periodo_id\": \"4e7cb250-c176-4ad0-b13e-af0544df7d89\", \"numero_monta\": 1, \"fecha_monta\": \"2025-11-02 10:47:00\", \"estatus\": \"PENDIENTE\", \"created_at\": \"2025-11-17 15:47:17\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'DESKTOP-BRTU0R4', '', '', '', '', '', '2025-11-17 10:47:17', 'SYSTEM'),
(118, 'servicios', 'ca2da07e-a95d-4ef4-ad80-41107401862b', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-17 10:47:17', 'SYSTEM', NULL, '{\"monta_id\": \"ca2da07e-a95d-4ef4-ad80-41107401862b\", \"periodo_id\": \"4e7cb250-c176-4ad0-b13e-af0544df7d89\", \"numero_monta\": 2, \"fecha_monta\": \"2025-11-03 10:47:00\", \"estatus\": \"PENDIENTE\", \"created_at\": \"2025-11-17 15:47:17\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'DESKTOP-BRTU0R4', '', '', '', '', '', '2025-11-17 10:47:17', 'SYSTEM'),
(119, 'servicios', 'bab2fda2-f2db-4372-82ea-084193d22829', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-17 10:47:17', 'SYSTEM', NULL, '{\"monta_id\": \"bab2fda2-f2db-4372-82ea-084193d22829\", \"periodo_id\": \"4e7cb250-c176-4ad0-b13e-af0544df7d89\", \"numero_monta\": 3, \"fecha_monta\": \"2025-11-04 10:47:00\", \"estatus\": \"PENDIENTE\", \"created_at\": \"2025-11-17 15:47:17\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'DESKTOP-BRTU0R4', '', '', '', '', '', '2025-11-17 10:47:17', 'SYSTEM'),
(120, 'servicios', '9aeaf86b-a84e-4262-a0c6-8cfa05bf8d2d', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-17 10:47:17', 'SYSTEM', NULL, '{\"monta_id\": \"9aeaf86b-a84e-4262-a0c6-8cfa05bf8d2d\", \"periodo_id\": \"4e7cb250-c176-4ad0-b13e-af0544df7d89\", \"numero_monta\": 4, \"fecha_monta\": \"2025-11-05 10:47:00\", \"estatus\": \"PENDIENTE\", \"created_at\": \"2025-11-17 15:47:17\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'DESKTOP-BRTU0R4', '', '', '', '', '', '2025-11-17 10:47:17', 'SYSTEM'),
(121, 'servicios', '9a8da6df-33bd-415c-b581-19fa758c7abd', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-17 10:47:17', 'SYSTEM', NULL, '{\"monta_id\": \"9a8da6df-33bd-415c-b581-19fa758c7abd\", \"periodo_id\": \"4e7cb250-c176-4ad0-b13e-af0544df7d89\", \"numero_monta\": 5, \"fecha_monta\": \"2025-11-06 10:47:00\", \"estatus\": \"PENDIENTE\", \"created_at\": \"2025-11-17 15:47:17\", \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'DESKTOP-BRTU0R4', '', '', '', '', '', '2025-11-17 10:47:17', 'SYSTEM'),
(122, 'periodos_servicio', '4e7cb250-c176-4ad0-b13e-af0544df7d89', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-17 10:47:22', 'SYSTEM', '{\"estado_periodo\":{\"old\":\"ABIERTO\",\"new\":\"\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'DESKTOP-BRTU0R4', '', '', '', '', '', '2025-11-17 10:47:22', 'SYSTEM'),
(123, 'servicios', 'd76f564a-f9dd-49eb-89f7-e2c47fe1ab08', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-17 10:47:22', 'SYSTEM', '{\"estatus\":{\"old\":\"PENDIENTE\",\"new\":\"REALIZADO\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'DESKTOP-BRTU0R4', '', '', '', '', '', '2025-11-17 10:47:22', 'SYSTEM'),
(124, 'servicios', 'ca2da07e-a95d-4ef4-ad80-41107401862b', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-17 10:47:22', 'SYSTEM', '{\"estatus\":{\"old\":\"PENDIENTE\",\"new\":\"REALIZADO\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'DESKTOP-BRTU0R4', '', '', '', '', '', '2025-11-17 10:47:22', 'SYSTEM'),
(125, 'servicios', 'bab2fda2-f2db-4372-82ea-084193d22829', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-17 10:47:22', 'SYSTEM', '{\"estatus\":{\"old\":\"PENDIENTE\",\"new\":\"REALIZADO\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'DESKTOP-BRTU0R4', '', '', '', '', '', '2025-11-17 10:47:22', 'SYSTEM'),
(126, 'servicios', '9aeaf86b-a84e-4262-a0c6-8cfa05bf8d2d', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-17 10:47:22', 'SYSTEM', '{\"estatus\":{\"old\":\"PENDIENTE\",\"new\":\"REALIZADO\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'DESKTOP-BRTU0R4', '', '', '', '', '', '2025-11-17 10:47:22', 'SYSTEM'),
(127, 'servicios', '9a8da6df-33bd-415c-b581-19fa758c7abd', 'UPDATE', '0', 'phpMyAdmin', 'system', '2025-11-17 10:47:22', 'SYSTEM', '{\"estatus\":{\"old\":\"PENDIENTE\",\"new\":\"REALIZADO\"}}', NULL, '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'DESKTOP-BRTU0R4', '', '', '', '', '', '2025-11-17 10:47:22', 'SYSTEM'),
(128, 'revisiones_servicio', '7a133f8e-bbed-4eac-b52f-d2bd16b3be2b', 'INSERT', '0', 'phpMyAdmin', 'system', '2025-11-17 10:47:22', 'SYSTEM', NULL, '{\"revision_id\": \"7a133f8e-bbed-4eac-b52f-d2bd16b3be2b\", \"periodo_id\": \"4e7cb250-c176-4ad0-b13e-af0544df7d89\", \"ciclo_control\": 1, \"fecha_programada\": \"2025-11-22\", \"fecha_realizada\": null, \"resultado\": null, \"observaciones\": null, \"created_by\": \"202b02fa-053d-48d5-a307-b52adb5525f4\", \"created_at\": \"2025-11-17 10:47:22\"}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'DESKTOP-BRTU0R4', '', '', '', '', '', '2025-11-17 10:47:22', 'SYSTEM'),
(129, 'periodos_servicio', '4e7cb250-c176-4ad0-b13e-af0544df7d89', 'UPDATE', '202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', '0', '2025-11-17 10:49:55', 'America/Caracas', '{\"estado_periodo\":{\"old\":\"\",\"new\":\"CERRADO\"}}', NULL, '::1', 'DESKTOP-BRTU0R4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/revisiones-servicio/7a133f8e-bbed-4eac-b52f-d2bd16b3be2b', 'DESKTOP-BRTU0R4', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-17 10:49:55', 'America/Caracas'),
(130, 'animales', 'l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', 'UPDATE', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-20 17:26:32', 'America/Caracas', '{\"estado\":{\"old\":\"ACTIVO\",\"new\":\"INACTIVO\"}}', NULL, '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/acontecimientos', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-20 17:26:32', 'America/Caracas'),
(131, 'animal_salud', 'b3740988-766e-44a0-9c87-d01fcad7a375', 'INSERT', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-20 17:36:20', 'America/Caracas', NULL, '{\"animal_salud_id\": \"b3740988-766e-44a0-9c87-d01fcad7a375\", \"animal_id\": \"l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0\", \"fecha_evento\": \"2025-11-20\", \"tipo_evento\": \"VACUNACION\", \"diagnostico\": null, \"severidad\": null, \"tratamiento\": null, \"medicamento\": \"asd\", \"dosis\": \"1\", \"via_administracion\": null, \"costo\": null, \"estado\": \"ABIERTO\", \"proxima_revision\": null, \"responsable\": null, \"observaciones\": \"asdasd\", \"created_at\": \"2025-11-20 17:36:20\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/acontecimientos', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-20 17:36:20', 'America/Caracas'),
(132, 'animal_salud', '27a61a15-6e0b-4681-9739-863017f6b436', 'INSERT', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-20 17:45:13', 'America/Caracas', NULL, '{\"animal_salud_id\": \"27a61a15-6e0b-4681-9739-863017f6b436\", \"animal_id\": \"k12c3441-b7f6-4af3-8a9e-43df2b28aee7\", \"fecha_evento\": \"2025-11-14\", \"tipo_evento\": \"REVISION\", \"diagnostico\": null, \"severidad\": null, \"tratamiento\": null, \"medicamento\": null, \"dosis\": null, \"via_administracion\": null, \"costo\": null, \"estado\": \"ABIERTO\", \"proxima_revision\": null, \"responsable\": null, \"observaciones\": \"asdasd\", \"created_at\": \"2025-11-20 17:45:13\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/acontecimientos', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-20 17:45:13', 'America/Caracas'),
(133, 'animal_salud', '416f6a7c-7d31-4772-bcd4-239a50fbcf24', 'INSERT', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-20 17:46:06', 'America/Caracas', NULL, '{\"animal_salud_id\": \"416f6a7c-7d31-4772-bcd4-239a50fbcf24\", \"animal_id\": \"k12c3441-b7f6-4af3-8a9e-43df2b28aee7\", \"fecha_evento\": \"2025-11-13\", \"tipo_evento\": \"VACUNACION\", \"diagnostico\": null, \"severidad\": null, \"tratamiento\": null, \"medicamento\": \"asd\", \"dosis\": \"2\", \"via_administracion\": null, \"costo\": null, \"estado\": \"ABIERTO\", \"proxima_revision\": null, \"responsable\": null, \"observaciones\": \"asdas\", \"created_at\": \"2025-11-20 17:46:06\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/acontecimientos', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-20 17:46:06', 'America/Caracas'),
(134, 'animal_salud', 'cb5ad581-af1e-4b0e-ae28-c913bc54c1dd', 'INSERT', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-20 17:48:33', 'America/Caracas', NULL, '{\"animal_salud_id\": \"cb5ad581-af1e-4b0e-ae28-c913bc54c1dd\", \"animal_id\": \"n45f1492-64f1-4f67-b81a-3e4bafcfb2f1\", \"fecha_evento\": \"2025-11-06\", \"tipo_evento\": \"VACUNACION\", \"diagnostico\": null, \"severidad\": null, \"tratamiento\": null, \"medicamento\": \"asdasd\", \"dosis\": \"asda\", \"via_administracion\": null, \"costo\": null, \"estado\": \"ABIERTO\", \"proxima_revision\": null, \"responsable\": null, \"observaciones\": \"asdasasdasd\", \"created_at\": \"2025-11-20 17:48:33\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/acontecimientos', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-20 17:48:33', 'America/Caracas'),
(135, 'animal_salud', '9796333b-09f0-4e48-92fd-1f64c29f2832', 'INSERT', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-20 17:48:33', 'America/Caracas', NULL, '{\"animal_salud_id\": \"9796333b-09f0-4e48-92fd-1f64c29f2832\", \"animal_id\": \"m34ef0bb-3a45-4cb8-9a51-c5ab91874aab\", \"fecha_evento\": \"2025-11-06\", \"tipo_evento\": \"VACUNACION\", \"diagnostico\": null, \"severidad\": null, \"tratamiento\": null, \"medicamento\": \"asdasd\", \"dosis\": \"asda\", \"via_administracion\": null, \"costo\": null, \"estado\": \"ABIERTO\", \"proxima_revision\": null, \"responsable\": null, \"observaciones\": \"asdasasdasd\", \"created_at\": \"2025-11-20 17:48:33\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/acontecimientos', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-20 17:48:33', 'America/Caracas'),
(136, 'animal_salud', '01bb2978-f188-4a5e-bea4-93b34cd3f021', 'INSERT', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-20 18:11:48', 'America/Caracas', NULL, '{\"animal_salud_id\": \"01bb2978-f188-4a5e-bea4-93b34cd3f021\", \"animal_id\": \"l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0\", \"fecha_evento\": \"2025-11-13\", \"tipo_evento\": \"VACUNACION\", \"diagnostico\": null, \"severidad\": null, \"tratamiento\": null, \"medicamento\": \"asd\", \"dosis\": \"1\", \"via_administracion\": null, \"costo\": null, \"estado\": \"ABIERTO\", \"proxima_revision\": null, \"responsable\": null, \"observaciones\": \"asdasd\", \"created_at\": \"2025-11-20 18:11:48\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/acontecimientos', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-20 18:11:48', 'America/Caracas'),
(137, 'animal_salud', 'e3a5b30b-1a9a-4dcd-8965-88e3e06bf673', 'INSERT', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-20 18:11:48', 'America/Caracas', NULL, '{\"animal_salud_id\": \"e3a5b30b-1a9a-4dcd-8965-88e3e06bf673\", \"animal_id\": \"m34ef0bb-3a45-4cb8-9a51-c5ab91874aab\", \"fecha_evento\": \"2025-11-13\", \"tipo_evento\": \"VACUNACION\", \"diagnostico\": null, \"severidad\": null, \"tratamiento\": null, \"medicamento\": \"asd\", \"dosis\": \"1\", \"via_administracion\": null, \"costo\": null, \"estado\": \"ABIERTO\", \"proxima_revision\": null, \"responsable\": null, \"observaciones\": \"asdasd\", \"created_at\": \"2025-11-20 18:11:48\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/acontecimientos', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-20 18:11:48', 'America/Caracas'),
(138, 'system_users', '202b02fa-053d-48d5-a307-b52adb5525f4', 'UPDATE', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-21 17:23:47', 'America/Caracas', '{\"nivel\":{\"old\":\"0\",\"new\":\"1\"},\"updated_at\":{\"old\":\"2025-11-10 14:19:36\",\"new\":\"2025-11-21 17:23:47\"},\"updated_by\":{\"old\":\"202b02fa-053d-48d5-a307-b52adb5525f4\",\"new\":\"d7518474-2d2f-4634-823f-71936565c110\"}}', NULL, '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/system_users/202b02fa-053d-48d5-a307-b52adb5525f4', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-21 17:23:47', 'America/Caracas'),
(139, 'system_users', '202b02fa-053d-48d5-a307-b52adb5525f4', 'UPDATE', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-21 17:24:07', 'America/Caracas', '{\"contrasena\":{\"old\":\"$2y$10$Ob9iRVKPw.DiqPASkyUibOERwWkE7PMQaSsmqkDFYc5iLvXdJqXle\",\"new\":\"$2y$10$Zc9Gk5CZGhQEqjBungBVdukN/kaUGH4Ur4zyPq4UZ7KlQr02lnqIO\"},\"updated_at\":{\"old\":\"2025-11-21 17:23:47\",\"new\":\"2025-11-21 17:24:07\"}}', NULL, '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/system_users/202b02fa-053d-48d5-a307-b52adb5525f4', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-21 17:24:07', 'America/Caracas'),
(140, 'menu', 'f21ee10a-2cce-452c-96f1-0f4bf9fe2090', 'INSERT', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-21 17:24:46', 'America/Caracas', NULL, '{\"menu_id\": \"f21ee10a-2cce-452c-96f1-0f4bf9fe2090\", \"categoria\": \"administracion\", \"nombre\": \"Crear Acontecimientos\", \"url\": \"acontecimientos\", \"icono\": \"\", \"user_level\": 1, \"orden\": 0, \"created_at\": \"2025-11-21 17:24:46\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/menus', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-21 17:24:46', 'America/Caracas'),
(141, 'menu', '70ce973a-97ea-419e-9111-17d36638e3c7', 'INSERT', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-21 17:24:57', 'America/Caracas', NULL, '{\"menu_id\": \"70ce973a-97ea-419e-9111-17d36638e3c7\", \"categoria\": \"administracion\", \"nombre\": \"Acontecimientos\", \"url\": \"acontecimientos/crear\", \"icono\": \"\", \"user_level\": 1, \"orden\": 0, \"created_at\": \"2025-11-21 17:24:57\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/menus', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-21 17:24:57', 'America/Caracas'),
(142, 'users_permisos', '1562e733-38b9-4305-be0d-fcaca5eb8221', 'INSERT', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-21 17:25:14', 'America/Caracas', NULL, '{\"users_permisos_id\": \"1562e733-38b9-4305-be0d-fcaca5eb8221\", \"user_id\": \"202b02fa-053d-48d5-a307-b52adb5525f4\", \"menu_id\": \"70ce973a-97ea-419e-9111-17d36638e3c7\", \"created_at\": \"2025-11-21 17:25:14\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/users-permisos', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-21 17:25:14', 'America/Caracas');
INSERT INTO `audit_log` (`audit_id`, `table_name`, `record_id`, `action_type`, `action_by`, `full_name`, `user_type`, `action_timestamp`, `action_timezone`, `changes`, `full_row`, `client_ip`, `client_hostname`, `user_agent`, `client_os`, `client_browser`, `domain_name`, `request_uri`, `server_hostname`, `client_country`, `client_region`, `client_city`, `client_zipcode`, `client_coordinates`, `geo_ip_timestamp`, `geo_ip_timezone`) VALUES
(143, 'users_permisos', '739a6c62-6476-427c-a3c6-8166d1ad18a2', 'INSERT', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-21 17:25:14', 'America/Caracas', NULL, '{\"users_permisos_id\": \"739a6c62-6476-427c-a3c6-8166d1ad18a2\", \"user_id\": \"202b02fa-053d-48d5-a307-b52adb5525f4\", \"menu_id\": \"f21ee10a-2cce-452c-96f1-0f4bf9fe2090\", \"created_at\": \"2025-11-21 17:25:14\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/users-permisos', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-21 17:25:14', 'America/Caracas'),
(144, 'users_permisos', 'ea8ce31e-a9ef-4695-8dbc-78557dbefbdf', 'INSERT', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-21 17:25:14', 'America/Caracas', NULL, '{\"users_permisos_id\": \"ea8ce31e-a9ef-4695-8dbc-78557dbefbdf\", \"user_id\": \"202b02fa-053d-48d5-a307-b52adb5525f4\", \"menu_id\": \"0aa79a19-946d-4993-90b1-84d352ad78a1\", \"created_at\": \"2025-11-21 17:25:14\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/users-permisos', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-21 17:25:14', 'America/Caracas'),
(145, 'users_permisos', '1562e733-38b9-4305-be0d-fcaca5eb8221', 'DELETE_PHYSICAL', '0', 'phpMyAdmin', 'system', '2025-11-21 17:25:35', 'SYSTEM', NULL, '{\"users_permisos_id\": \"1562e733-38b9-4305-be0d-fcaca5eb8221\", \"user_id\": \"202b02fa-053d-48d5-a307-b52adb5525f4\", \"menu_id\": \"70ce973a-97ea-419e-9111-17d36638e3c7\", \"created_at\": \"2025-11-21 17:25:14\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\", \"updated_at\": null, \"updated_by\": null, \"deleted_at\": null, \"deleted_by\": null}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'IT-CB01', '', '', '', '', '', '2025-11-21 17:25:35', 'SYSTEM'),
(146, 'menu', 'f21ee10a-2cce-452c-96f1-0f4bf9fe2090', 'UPDATE', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-21 17:26:03', 'America/Caracas', '{\"url\":{\"old\":\"acontecimientos\",\"new\":\"acontecimientos/crear\"}}', NULL, '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/menus/f21ee10a-2cce-452c-96f1-0f4bf9fe2090', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-21 17:26:03', 'America/Caracas'),
(147, 'menu', '70ce973a-97ea-419e-9111-17d36638e3c7', 'UPDATE', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-21 17:26:08', 'America/Caracas', '{\"url\":{\"old\":\"acontecimientos/crear\",\"new\":\"acontecimientos\"}}', NULL, '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/menus/70ce973a-97ea-419e-9111-17d36638e3c7', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-21 17:26:08', 'America/Caracas'),
(148, 'users_permisos', 'd349f835-8f99-49a0-909d-b9fd2385b77d', 'INSERT', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-21 17:31:11', 'America/Caracas', NULL, '{\"users_permisos_id\": \"d349f835-8f99-49a0-909d-b9fd2385b77d\", \"user_id\": \"202b02fa-053d-48d5-a307-b52adb5525f4\", \"menu_id\": \"1be82974-a797-4bea-aae1-0d7112727ec4\", \"created_at\": \"2025-11-21 17:31:11\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/users-permisos', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-21 17:31:11', 'America/Caracas'),
(149, 'users_permisos', '739a6c62-6476-427c-a3c6-8166d1ad18a2', 'DELETE_PHYSICAL', '0', 'phpMyAdmin', 'system', '2025-11-21 17:32:58', 'SYSTEM', NULL, '{\"users_permisos_id\": \"739a6c62-6476-427c-a3c6-8166d1ad18a2\", \"user_id\": \"202b02fa-053d-48d5-a307-b52adb5525f4\", \"menu_id\": \"f21ee10a-2cce-452c-96f1-0f4bf9fe2090\", \"created_at\": \"2025-11-21 17:25:14\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\", \"updated_at\": null, \"updated_by\": null, \"deleted_at\": null, \"deleted_by\": null}', '127.0.0.1', 'localhost', 'phpMyAdmin', 'unknown', 'phpMyAdmin', '', '', 'IT-CB01', '', '', '', '', '', '2025-11-21 17:32:58', 'SYSTEM'),
(150, 'users_permisos', 'c7966efb-64c9-45b1-aa2e-c61af76a6cef', 'INSERT', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-21 17:32:58', 'America/Caracas', NULL, '{\"users_permisos_id\": \"c7966efb-64c9-45b1-aa2e-c61af76a6cef\", \"user_id\": \"202b02fa-053d-48d5-a307-b52adb5525f4\", \"menu_id\": \"70ce973a-97ea-419e-9111-17d36638e3c7\", \"created_at\": \"2025-11-21 17:32:58\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/users-permisos', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-21 17:32:58', 'America/Caracas'),
(151, 'users_permisos', 'aae73a28-a1b0-4e1c-a4a1-35bd10e7819a', 'INSERT', 'd7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', '0', '2025-11-21 17:33:22', 'America/Caracas', NULL, '{\"users_permisos_id\": \"aae73a28-a1b0-4e1c-a4a1-35bd10e7819a\", \"user_id\": \"202b02fa-053d-48d5-a307-b52adb5525f4\", \"menu_id\": \"f21ee10a-2cce-452c-96f1-0f4bf9fe2090\", \"created_at\": \"2025-11-21 17:33:22\", \"created_by\": \"d7518474-2d2f-4634-823f-71936565c110\"}', '::1', 'IT-CB01.forum.local', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'Windows 10', 'Google Chrome', 'localhost', '/ERP_SISUPP/api/users-permisos', 'IT-CB01', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', '2025-11-21 17:33:22', 'America/Caracas');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `camadas`
--

CREATE TABLE `camadas` (
  `camada_id` char(36) NOT NULL,
  `parto_id` char(36) NOT NULL,
  `madre_id` char(36) NOT NULL,
  `cantidad_inicial` smallint(5) UNSIGNED NOT NULL,
  `estado_camada` enum('ACTIVA','CERRADA') NOT NULL DEFAULT 'ACTIVA',
  `created_at` datetime DEFAULT NULL,
  `created_by` char(36) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `camadas`
--

INSERT INTO `camadas` (`camada_id`, `parto_id`, `madre_id`, `cantidad_inicial`, `estado_camada`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('56ef9c0f-3d2e-46c6-ab4d-ddb99696b833', '44b8bebe-577d-4fa1-8d8d-aa61cbb87e08', 'l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', 20, 'ACTIVA', '2025-11-09 10:56:33', '202b02fa-053d-48d5-a307-b52adb5525f4', '2025-11-09 10:56:33', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL);

--
-- Disparadores `camadas`
--
DELIMITER $$
CREATE TRIGGER `trg_camadas_delete` BEFORE DELETE ON `camadas` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'camadas', OLD.camada_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'camada_id', OLD.camada_id,
      'parto_id', OLD.parto_id,
      'madre_id', OLD.madre_id,
      'cantidad_inicial', OLD.cantidad_inicial,
      'estado_camada', OLD.estado_camada,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_camadas_delete_logical` AFTER UPDATE ON `camadas` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'camadas', OLD.camada_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'camada_id', OLD.camada_id,
        'parto_id', OLD.parto_id,
        'madre_id', OLD.madre_id,
        'cantidad_inicial', OLD.cantidad_inicial,
        'estado_camada', OLD.estado_camada,
        'created_at', OLD.created_at,
        'created_by', OLD.created_by,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_camadas_insert` AFTER INSERT ON `camadas` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'camadas', NEW.camada_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'camada_id', NEW.camada_id,
      'parto_id', NEW.parto_id,
      'madre_id', NEW.madre_id,
      'cantidad_inicial', NEW.cantidad_inicial,
      'estado_camada', NEW.estado_camada,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_camadas_update` AFTER UPDATE ON `camadas` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.parto_id <> NEW.parto_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"parto_id":{"old":"', escape_json(OLD.parto_id), '","new":"', escape_json(NEW.parto_id), '"}');
  END IF;
  IF OLD.madre_id <> NEW.madre_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"madre_id":{"old":"', escape_json(OLD.madre_id), '","new":"', escape_json(NEW.madre_id), '"}');
  END IF;
  IF OLD.cantidad_inicial <> NEW.cantidad_inicial THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"cantidad_inicial":{"old":"', escape_json(OLD.cantidad_inicial), '","new":"', escape_json(NEW.cantidad_inicial), '"}');
  END IF;
  IF OLD.estado_camada <> NEW.estado_camada THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"estado_camada":{"old":"', escape_json(OLD.estado_camada), '","new":"', escape_json(NEW.estado_camada), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'camadas', OLD.camada_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `camada_bajas`
--

CREATE TABLE `camada_bajas` (
  `baja_id` char(36) NOT NULL,
  `camada_id` char(36) NOT NULL,
  `fecha_baja` date NOT NULL,
  `cantidad` smallint(5) UNSIGNED NOT NULL DEFAULT 1,
  `causa_deceso` varchar(255) DEFAULT NULL,
  `documento_acta_url` varchar(255) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` char(36) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `camada_bajas`
--

INSERT INTO `camada_bajas` (`baja_id`, `camada_id`, `fecha_baja`, `cantidad`, `causa_deceso`, `documento_acta_url`, `observaciones`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('9e833325-aeed-4833-b3b1-70633c07d58f', '56ef9c0f-3d2e-46c6-ab4d-ddb99696b833', '2025-11-09', 1, 'APLASTAMIENTO', NULL, 'fsafa', '2025-11-09 10:56:50', '202b02fa-053d-48d5-a307-b52adb5525f4', '2025-11-09 10:56:50', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL);

--
-- Disparadores `camada_bajas`
--
DELIMITER $$
CREATE TRIGGER `trg_camada_bajas_delete` BEFORE DELETE ON `camada_bajas` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,

    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'camada_bajas', OLD.baja_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'baja_id', OLD.baja_id,
      'camada_id', OLD.camada_id,
      'fecha_baja', OLD.fecha_baja,
      'cantidad', OLD.cantidad,
      'causa_deceso', OLD.causa_deceso,
      'documento_acta_url', OLD.documento_acta_url,
      'observaciones', OLD.observaciones,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_camada_bajas_delete_logical` AFTER UPDATE ON `camada_bajas` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'camada_bajas', OLD.baja_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'baja_id', OLD.baja_id,
        'camada_id', OLD.camada_id,
        'fecha_baja', OLD.fecha_baja,
        'cantidad', OLD.cantidad,
        'causa_deceso', OLD.causa_deceso,
        'documento_acta_url', OLD.documento_acta_url,
        'observaciones', OLD.observaciones,
        'created_at', OLD.created_at,
        'created_by', OLD.created_by,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_camada_bajas_insert` AFTER INSERT ON `camada_bajas` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'camada_bajas', NEW.baja_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'baja_id', NEW.baja_id,
      'camada_id', NEW.camada_id,
      'fecha_baja', NEW.fecha_baja,
      'cantidad', NEW.cantidad,
      'causa_deceso', NEW.causa_deceso,
      'documento_acta_url', NEW.documento_acta_url,
      'observaciones', NEW.observaciones,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_camada_bajas_update` AFTER UPDATE ON `camada_bajas` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.camada_id <> NEW.camada_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"camada_id":{"old":"', escape_json(OLD.camada_id), '","new":"', escape_json(NEW.camada_id), '"}');
  END IF;
  IF OLD.fecha_baja <> NEW.fecha_baja THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"fecha_baja":{"old":"', escape_json(OLD.fecha_baja), '","new":"', escape_json(NEW.fecha_baja), '"}');
  END IF;
  IF OLD.cantidad <> NEW.cantidad THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"cantidad":{"old":"', escape_json(OLD.cantidad), '","new":"', escape_json(NEW.cantidad), '"}');
  END IF;
  IF OLD.causa_deceso <> NEW.causa_deceso THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"causa_deceso":{"old":"', escape_json(OLD.causa_deceso), '","new":"', escape_json(NEW.causa_deceso), '"}');
  END IF;
  IF OLD.documento_acta_url <> NEW.documento_acta_url THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"documento_acta_url":{"old":"', escape_json(OLD.documento_acta_url), '","new":"', escape_json(NEW.documento_acta_url), '"}');
  END IF;
  IF OLD.observaciones <> NEW.observaciones THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"observaciones":{"old":"', escape_json(OLD.observaciones), '","new":"', escape_json(NEW.observaciones), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'camada_bajas', OLD.baja_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuraciones`
--

CREATE TABLE `configuraciones` (
  `config_id` char(36) NOT NULL,
  `config_key` varchar(100) NOT NULL COMMENT 'Clave única para la configuración (ej: permitir_registro_consanguineo)',
  `config_value` varchar(255) DEFAULT NULL COMMENT 'Valor de la configuración (ej: 1 o 0)',
  `descripcion` text DEFAULT NULL COMMENT 'Explicación de lo que hace la configuración',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `configuraciones`
--

INSERT INTO `configuraciones` (`config_id`, `config_key`, `config_value`, `descripcion`, `created_at`, `updated_at`) VALUES
('9927c9e7-d35a-4b1c-93b0-c078894cc9es', 'permitir_registro_consanguineo', '1', 'Permitir (1) o denegar (0) el registro de nuevos animales cuyos padres (madre_id y padre_id) tengan un parentesco sanguíneo.', '2025-10-21 10:46:10', '2025-10-22 10:13:55');

--
-- Disparadores `configuraciones`
--
DELIMITER $$
CREATE TRIGGER `trg_configuraciones_delete` BEFORE DELETE ON `configuraciones` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'configuraciones', OLD.config_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'config_id', OLD.config_id,
      'config_key', OLD.config_key,
      'config_value', OLD.config_value,
      'descripcion', OLD.descripcion,
      'created_at', OLD.created_at,
      'updated_at', OLD.updated_at
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_configuraciones_insert` AFTER INSERT ON `configuraciones` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'configuraciones', NEW.config_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'config_id', NEW.config_id,
      'config_key', NEW.config_key,
      'config_value', NEW.config_value,
      'descripcion', NEW.descripcion,
      'created_at', NEW.created_at
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_configuraciones_update` AFTER UPDATE ON `configuraciones` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.config_key <> NEW.config_key THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"config_key":{"old":"', escape_json(OLD.config_key), '","new":"', escape_json(NEW.config_key), '"}');
  END IF;
  IF OLD.config_value <> NEW.config_value THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"config_value":{"old":"', escape_json(OLD.config_value), '","new":"', escape_json(NEW.config_value), '"}');
  END IF;
  IF OLD.descripcion <> NEW.descripcion THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"descripcion":{"old":"', escape_json(OLD.descripcion), '","new":"', escape_json(NEW.descripcion), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'configuraciones', OLD.config_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fincas`
--

CREATE TABLE `fincas` (
  `finca_id` char(36) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `ubicacion` varchar(255) DEFAULT NULL,
  `estado` enum('ACTIVA','INACTIVA') NOT NULL DEFAULT 'ACTIVA',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by` char(36) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `fincas`
--

INSERT INTO `fincas` (`finca_id`, `nombre`, `ubicacion`, `estado`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('06fcbfc8-ffc7-4956-b99d-77d879d772b7', 'Finca Demo Editada rd20er', 'Coordenadas XYZ, Municipio AB', 'ACTIVA', '2025-10-02 10:52:16', '06fcbfc8-ffc7-4956-b99d-77d879d772b7', '2025-10-04 09:43:03', '06fcbfc8-ffc7-4956-b99d-77d879d772b7', NULL, NULL);

--
-- Disparadores `fincas`
--
DELIMITER $$
CREATE TRIGGER `trg_fincas_delete` BEFORE DELETE ON `fincas` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'fincas', OLD.finca_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'finca_id', OLD.finca_id,
      'nombre', OLD.nombre,
      'ubicacion', OLD.ubicacion,
      'estado', OLD.estado,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_fincas_delete_logical` AFTER UPDATE ON `fincas` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'fincas', OLD.finca_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'finca_id', OLD.finca_id,
        'nombre', OLD.nombre,
        'ubicacion', OLD.ubicacion,
        'estado', OLD.estado,
        'created_at', OLD.created_at,
        'created_by', OLD.created_by,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_fincas_insert` AFTER INSERT ON `fincas` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'fincas', NEW.finca_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'finca_id', NEW.finca_id,
      'nombre', NEW.nombre,
      'ubicacion', NEW.ubicacion,
      'estado', NEW.estado,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_fincas_update` AFTER UPDATE ON `fincas` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.nombre <> NEW.nombre THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"nombre":{"old":"', escape_json(OLD.nombre), '","new":"', escape_json(NEW.nombre), '"}');
  END IF;
  IF OLD.ubicacion <> NEW.ubicacion THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"ubicacion":{"old":"', escape_json(OLD.ubicacion), '","new":"', escape_json(NEW.ubicacion), '"}');
  END IF;
  IF OLD.estado <> NEW.estado THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"estado":{"old":"', escape_json(OLD.estado), '","new":"', escape_json(NEW.estado), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'fincas', OLD.finca_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `incidencias`
--

CREATE TABLE `incidencias` (
  `incidencia_id` char(36) NOT NULL,
  `correlativo` varchar(12) NOT NULL,
  `animal_id` char(36) NOT NULL,
  `tipo` enum('RECHAZO_CRIAS','FUGA','APLASTAMIENTO','AGRESIVIDAD','RIÑA','OTRA') NOT NULL,
  `fecha_evento` datetime NOT NULL,
  `descripcion` text DEFAULT NULL,
  `fotografia_url` varchar(255) DEFAULT NULL,
  `responsable` varchar(100) DEFAULT NULL,
  `area_id` char(36) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by` char(36) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `incidencias`
--

INSERT INTO `incidencias` (`incidencia_id`, `correlativo`, `animal_id`, `tipo`, `fecha_evento`, `descripcion`, `fotografia_url`, `responsable`, `area_id`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('5df96cef-22c1-4928-933e-ab1bfc493be0', '', 'ab29db65-86d8-46c6-bc47-85a988176e4a', 'RIÑA', '2025-11-08 22:17:00', 'fsa', NULL, 'fsa', '9927c9e7-d35a-4b1c-93b0-c078894cc9ef', '2025-11-08 22:17:13', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, '2025-11-09 10:58:43', '202b02fa-053d-48d5-a307-b52adb5525f4'),
('6b89b7e0-5986-4bde-9ce4-058eecf40682', '', 'ab29db65-86d8-46c6-bc47-85a988176e4a', 'APLASTAMIENTO', '2025-11-08 21:02:00', NULL, NULL, NULL, '9927c9e7-d35a-4b1c-93b0-c078894cc9ef', '2025-11-08 21:02:53', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, '2025-11-09 13:02:23', '202b02fa-053d-48d5-a307-b52adb5525f4'),
('7123afd6-589f-4bb4-9eec-b7f7c302fe01', '', 's90d1b25-1f83-4e74-a730-fb94fca8f9a5', 'RIÑA', '2025-11-09 13:48:00', NULL, NULL, NULL, '486a43b4-565a-45d8-af5c-5efc26fb54a0', '2025-11-09 13:48:54', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, '2025-11-09 13:52:51', '202b02fa-053d-48d5-a307-b52adb5525f4'),
('7b30d53d-8e74-4290-a5c7-3f6a8bb95d75', '', 'ab29db65-86d8-46c6-bc47-85a988176e4a', 'RIÑA', '2025-11-08 21:48:00', 'fsa', NULL, 'fsa', '9927c9e7-d35a-4b1c-93b0-c078894cc9ef', '2025-11-08 21:48:17', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, '2025-11-09 11:03:29', '202b02fa-053d-48d5-a307-b52adb5525f4'),
('805af77c-ff5a-4736-9688-6e233ca217d5', 'INC-000001', 's90d1b25-1f83-4e74-a730-fb94fca8f9a5', 'RIÑA', '2025-11-10 14:54:00', 'fsa', NULL, 'fsa', '9927c9e7-d35a-4b1c-93b0-c078894cc9ef', '2025-11-10 14:56:20', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, '2025-11-10 14:56:50', '202b02fa-053d-48d5-a307-b52adb5525f4'),
('ad09d518-2565-4a4c-a0f0-294be309f6c0', '', 'l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', 'APLASTAMIENTO', '2025-11-09 00:00:00', 'Aplastamiento de 1 lechón(es). Baja registrada.', NULL, 'sistema', NULL, '2025-11-09 10:56:50', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, '2025-11-09 20:35:27', '202b02fa-053d-48d5-a307-b52adb5525f4'),
('ae805823-cc01-46e4-87f2-5e9d3e523b23', 'INC-000002', 's90d1b25-1f83-4e74-a730-fb94fca8f9a5', 'RIÑA', '2025-11-10 14:57:00', 'fsa', NULL, 'fsa', '9927c9e7-d35a-4b1c-93b0-c078894cc9ef', '2025-11-10 14:58:05', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('b675454b-dba6-4d90-863b-bfc83cba3af2', '', 'ab29db65-86d8-46c6-bc47-85a988176e4a', 'RIÑA', '2025-11-09 14:04:00', NULL, NULL, NULL, '9927c9e7-d35a-4b1c-93b0-c078894cc9ef', '2025-11-09 14:04:12', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('f1c521d5-bcd3-4d7a-b1c6-ded5c9bc1192', '', 'ab29db65-86d8-46c6-bc47-85a988176e4a', 'RIÑA', '2025-11-08 20:54:00', NULL, NULL, NULL, '9927c9e7-d35a-4b1c-93b0-c078894cc9ef', '2025-11-08 20:56:05', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, '2025-11-08 20:56:34', '202b02fa-053d-48d5-a307-b52adb5525f4');

--
-- Disparadores `incidencias`
--
DELIMITER $$
CREATE TRIGGER `trg_incidencias_delete` BEFORE DELETE ON `incidencias` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'incidencias', OLD.incidencia_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'incidencia_id', OLD.incidencia_id,
      'animal_id', OLD.animal_id,
      'tipo', OLD.tipo,
      'fecha_evento', OLD.fecha_evento,
      'descripcion', OLD.descripcion,
      'responsable', OLD.responsable,
      'area_id', OLD.area_id,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_incidencias_delete_logical` AFTER UPDATE ON `incidencias` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'incidencias', OLD.incidencia_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'incidencia_id', OLD.incidencia_id,
        'animal_id', OLD.animal_id,
        'tipo', OLD.tipo,
        'fecha_evento', OLD.fecha_evento,
        'descripcion', OLD.descripcion,
        'responsable', OLD.responsable,
        'area_id', OLD.area_id,
        'created_at', OLD.created_at,
        'created_by', OLD.created_by,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_incidencias_insert` AFTER INSERT ON `incidencias` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'incidencias', NEW.incidencia_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'incidencia_id', NEW.incidencia_id,
      'animal_id', NEW.animal_id,
      'tipo', NEW.tipo,
      'fecha_evento', NEW.fecha_evento,
      'descripcion', NEW.descripcion,
      'responsable', NEW.responsable,
      'area_id', NEW.area_id,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_incidencias_update` AFTER UPDATE ON `incidencias` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.animal_id <> NEW.animal_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"animal_id":{"old":"', escape_json(OLD.animal_id), '","new":"', escape_json(NEW.animal_id), '"}');
  END IF;
  IF OLD.tipo <> NEW.tipo THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"tipo":{"old":"', escape_json(OLD.tipo), '","new":"', escape_json(NEW.tipo), '"}');
  END IF;
  IF OLD.fecha_evento <> NEW.fecha_evento THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"fecha_evento":{"old":"', escape_json(OLD.fecha_evento), '","new":"', escape_json(NEW.fecha_evento), '"}');
  END IF;
  IF OLD.descripcion <> NEW.descripcion THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"descripcion":{"old":"', escape_json(OLD.descripcion), '","new":"', escape_json(NEW.descripcion), '"}');
  END IF;
  IF OLD.responsable <> NEW.responsable THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"responsable":{"old":"', escape_json(OLD.responsable), '","new":"', escape_json(NEW.responsable), '"}');
  END IF;
  IF OLD.area_id <> NEW.area_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"area_id":{"old":"', escape_json(OLD.area_id), '","new":"', escape_json(NEW.area_id), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'incidencias', OLD.incidencia_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `menu`
--

CREATE TABLE `menu` (
  `menu_id` char(36) NOT NULL,
  `categoria` enum('area','finca','aprisco','reporte_dano','montas','partos','animales','alertas','usuarios','respaldos','infraestructura','administracion') DEFAULT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `icono` varchar(255) DEFAULT NULL,
  `user_level` int(11) NOT NULL DEFAULT 0,
  `orden` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `created_by` char(36) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `menu`
--

INSERT INTO `menu` (`menu_id`, `categoria`, `nombre`, `url`, `icono`, `user_level`, `orden`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('0aa79a19-946d-4993-90b1-84d352ad78a1', 'administracion', 'Inicio', 'dashboard', 'mdi mdi-view-dashboard', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL),
('0aa89a19-946d-4993-90b1-84d352ad77a1', 'animales', 'Gestación', 'animales/gestacion', 'mdi mdi-dna', 1, 0, '2025-11-12 13:49:06', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('1be82974-a797-4bea-aae1-0d7112727ec4', 'animales', 'Gestión de Rebaño', 'animales', 'mdi mdi-sheep', 1, 4, '2025-10-05 16:54:24', 'd7518474-2d2f-4634-823f-71936565c110', '2025-11-03 09:46:46', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL),
('22f9bbb0-4518-4079-b9e9-1b901f934288', 'infraestructura', 'Estado', 'reportes-administracion', 'mdi mdi-shield-check', 1, 2, '2025-11-12 13:45:25', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('25d17a58-3186-48ed-81cc-8d396074b62d', 'usuarios', 'Modulos', 'modulos', 'mdi mdi-view-module', 0, 0, '2025-10-04 11:28:50', 'd7518474-2d2f-4634-823f-71936565c110', '2025-10-05 17:19:35', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL),
('35f8606a-a133-11f0-a92b-74d02b268d93', 'usuarios', 'Usuarios', 'users', 'mdi mdi-account-group', 0, 1, NULL, NULL, '2025-10-05 17:19:29', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL),
('4aeb6638-fb70-40c2-bf53-8b73faae4389', 'reporte_dano', 'Reportes (Administración', 'reportes-administracion', 'mdi mdi-shield-check', 1, 0, '2025-11-03 09:42:58', 'd7518474-2d2f-4634-823f-71936565c110', '2025-11-03 09:54:39', 'd7518474-2d2f-4634-823f-71936565c110', '2025-11-12 13:44:59', '202b02fa-053d-48d5-a307-b52adb5525f4'),
('4f98a648-1410-4541-9329-d1b59f86c1d6', 'animales', 'Tabulador de Peso', 'animales/tabuladores', 'mdi mdi-scale-balance', 1, 0, '2025-11-03 09:45:36', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('50e9bd96-c2b4-4db8-bfe2-53ff25a7e8e7', 'montas', 'Gestaciones', 'animales/gestacion', 'mdi mdi-dna', 1, 0, '2025-11-03 09:36:55', 'd7518474-2d2f-4634-823f-71936565c110', '2025-11-03 09:53:23', 'd7518474-2d2f-4634-823f-71936565c110', '2025-11-12 13:49:21', '202b02fa-053d-48d5-a307-b52adb5525f4'),
('6bd44c34-2ee4-43f5-a0b7-90fcfa1a0092', 'animales', 'Gestación', 'animales/gestacion', 'mdi-calendar-heart', 1, 0, '2025-11-03 09:46:07', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, '2025-11-03 09:47:47', 'd7518474-2d2f-4634-823f-71936565c110'),
('6d583c24-a39e-11f0-8f58-2a144d1110c0', 'animales', 'Registro de montas', 'montas', 'mdi mdi-reproduction', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL),
('70ce973a-97ea-419e-9111-17d36638e3c7', 'administracion', 'Acontecimientos', 'acontecimientos', '', 1, 0, '2025-11-21 17:24:57', 'd7518474-2d2f-4634-823f-71936565c110', '2025-11-21 17:26:08', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL),
('74185a93-9c37-4941-8f56-32dfd4924b0e', 'usuarios', 'Configuraciones', 'configuraciones', 'mdi mdi-cog', 1, 0, '2025-11-03 09:41:38', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('920a038d-e341-4c61-9915-d35fb41d1a6b', 'infraestructura', 'Registro', 'infraestructura', 'mdi mdi-office-building-marker', 1, 0, '2025-10-04 10:41:51', '920a038d-e341-4c61-9915-d35fb41d1a6b', '2025-11-12 13:43:21', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL),
('9227b423-d6f7-46e9-8d6e-1faf3edac49c', 'animales', 'Incidencias de Animales', 'animales/incidencias', 'mdi mdi-dna', 1, 0, '2025-11-03 09:44:39', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('95765136-0404-4810-8dc4-5b38751c8522', 'partos', 'asdasd', 'https://github.com/jesuszapataDev/digital-signature-form.git', '0', 1, 0, '2025-10-04 10:05:19', '95765136-0404-4810-8dc4-5b38751c8522', '2025-10-04 10:12:35', '95765136-0404-4810-8dc4-5b38751c8522', '2025-10-04 10:12:40', '95765136-0404-4810-8dc4-5b38751c8522'),
('ba3b2b7e-a7d8-11f0-872b-00e04cf70151', 'usuarios', 'Gestor de Sesiones', 'sesiones', 'mdi mdi-account', 0, 2, NULL, NULL, NULL, NULL, NULL, NULL),
('bc2f3fd9-46bd-44dc-baac-b057feef025c', 'reporte_dano', 'Reportes (Usuario)', 'reportes-usuario', 'mdi mdi-file-send', 1, 0, '2025-11-03 09:44:00', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, '2025-11-12 13:45:02', '202b02fa-053d-48d5-a307-b52adb5525f4'),
('c8f8c40f-0d7e-4c6a-bf7f-8f79e15c61d5', 'animales', 'Agenda reproductiva', 'agenda_reproductiva', 'mdi mdi-calendar-arrow-right', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL),
('d6b0362d-a06f-4abe-a8ce-64621409214d', 'animales', 'Acontecimientos', 'acontecimientos', 'mdi mdi-calendar-text', 1, 0, '2025-11-12 20:11:42', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('d7b72d0b-d13e-4599-b805-539731cf5087', 'infraestructura', 'Reporte de daños', 'reportes-usuario', 'mdi mdi-file-send', 1, 1, '2025-11-12 13:45:54', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('f21ee10a-2cce-452c-96f1-0f4bf9fe2090', 'administracion', 'Crear Acontecimientos', 'acontecimientos/crear', '', 1, 0, '2025-11-21 17:24:46', 'd7518474-2d2f-4634-823f-71936565c110', '2025-11-21 17:26:03', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL);

--
-- Disparadores `menu`
--
DELIMITER $$
CREATE TRIGGER `trg_menu_delete` BEFORE DELETE ON `menu` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'menu', OLD.menu_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'menu_id', OLD.menu_id,
      'categoria', OLD.categoria,
      'nombre', OLD.nombre,
      'url', OLD.url,
      'icono', OLD.icono,
      'user_level', OLD.user_level,
      'orden', OLD.orden,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_menu_delete_logical` AFTER UPDATE ON `menu` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'menu', OLD.menu_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'menu_id', OLD.menu_id,
        'categoria', OLD.categoria,
        'nombre', OLD.nombre,
        'url', OLD.url,
        'icono', OLD.icono,
        'user_level', OLD.user_level,
        'orden', OLD.orden,
        'created_at', OLD.created_at,
        'created_by', OLD.created_by,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_menu_insert` AFTER INSERT ON `menu` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'menu', NEW.menu_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'menu_id', NEW.menu_id,
      'categoria', NEW.categoria,
      'nombre', NEW.nombre,
      'url', NEW.url,
      'icono', NEW.icono,
      'user_level', NEW.user_level,
      'orden', NEW.orden,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_menu_update` AFTER UPDATE ON `menu` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.categoria <> NEW.categoria THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"categoria":{"old":"', escape_json(OLD.categoria), '","new":"', escape_json(NEW.categoria), '"}');
  END IF;
  IF OLD.nombre <> NEW.nombre THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"nombre":{"old":"', escape_json(OLD.nombre), '","new":"', escape_json(NEW.nombre), '"}');
  END IF;
  IF OLD.url <> NEW.url THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"url":{"old":"', escape_json(OLD.url), '","new":"', escape_json(NEW.url), '"}');
  END IF;
  IF OLD.icono <> NEW.icono THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"icono":{"old":"', escape_json(OLD.icono), '","new":"', escape_json(NEW.icono), '"}');
  END IF;
  IF OLD.user_level <> NEW.user_level THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"user_level":{"old":"', escape_json(OLD.user_level), '","new":"', escape_json(NEW.user_level), '"}');
  END IF;
  IF OLD.orden <> NEW.orden THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"orden":{"old":"', escape_json(OLD.orden), '","new":"', escape_json(NEW.orden), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'menu', OLD.menu_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `menu_categorias`
--

CREATE TABLE `menu_categorias` (
  `categoria_id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `orden` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `menu_categorias`
--

INSERT INTO `menu_categorias` (`categoria_id`, `nombre`, `orden`) VALUES
(1, 'infraestructura', 1),
(2, 'finca', 4),
(3, 'aprisco', 5),
(4, 'animales', 2),
(5, 'montas', 6),
(6, 'partos', 7),
(7, 'reporte_dano', 8),
(8, 'alertas', 9),
(9, 'usuarios', 3),
(10, 'respaldos', 10),
(11, 'administracion', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notifications`
--

CREATE TABLE `notifications` (
  `notifications_id` char(36) NOT NULL,
  `template_key` varchar(255) NOT NULL,
  `template_params` longtext DEFAULT NULL COMMENT 'JSON object with template variables',
  `route` varchar(255) DEFAULT NULL,
  `module` varchar(255) NOT NULL,
  `rol` varchar(255) DEFAULT NULL,
  `user_id` char(36) DEFAULT NULL,
  `new` tinyint(1) NOT NULL DEFAULT 1,
  `read_unread` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `notifications`
--

INSERT INTO `notifications` (`notifications_id`, `template_key`, `template_params`, `route`, `module`, `rol`, `user_id`, `new`, `read_unread`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('083ce13f-ed80-452d-8175-c4b031960f21', 'acon_deceso_registrado', '{\"deceso_fecha\":\"2025-11-20\",\"deceso_causa\":\"asdasd\",\"detalle_animales\":\"1 animal\"}', '/animales', 'acontecimientos', 'administrator', 'd7518474-2d2f-4634-823f-71936565c110', 0, 0, '2025-11-20 17:26:32', 'd7518474-2d2f-4634-823f-71936565c110', '2025-11-20 17:29:36', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL),
('0b4caa47-2a85-4f94-b3e2-c0bddc4d7be6', 'acon_vacunacion_registrada', '{\"vacuna_nombre\":\"asd\",\"vacuna_fecha\":\"2025-11-13\",\"vacuna_dosis\":\"1\",\"detalle_animales\":\"2 animales\"}', '/animales', 'acontecimientos', 'administrator', 'd7518474-2d2f-4634-823f-71936565c110', 1, 0, '2025-11-20 18:11:48', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('454aa048-e401-4edc-8f8d-a89e95ec0d70', 'acon_vacunacion_registrada', '{\"vacuna_nombre\":\"asd\",\"vacuna_fecha\":\"2025-11-13\",\"vacuna_dosis\":\"2\",\"detalle_animales\":\"1 animal\"}', '/animales', 'acontecimientos', 'administrator', 'd7518474-2d2f-4634-823f-71936565c110', 0, 0, '2025-11-20 17:46:06', 'd7518474-2d2f-4634-823f-71936565c110', '2025-11-20 18:06:47', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL),
('4a120936-3e31-4086-b838-6ebdcc43a553', 'repro_revision_20_21_due', '{\"dia\":\"21\",\"fecha_programada\":\"2025-11-22\",\"hembra_identificador\":\"CRU-001\"}', '/revisiones_servicio?periodo_id=4e7cb250-c176-4ad0-b13e-af0544df7d89', 'reproduccion', 'administrator', '202b02fa-053d-48d5-a307-b52adb5525f4', 0, 0, '2025-11-17 10:47:22', '202b02fa-053d-48d5-a307-b52adb5525f4', '2025-11-17 10:50:00', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL),
('5452477f-b5f9-4429-971c-eed93d2249cb', 'acon_vacunacion_registrada', '{\"vacuna_nombre\":\"asdasd\",\"vacuna_fecha\":\"2025-11-06\",\"vacuna_dosis\":\"asda\",\"detalle_animales\":\"2 animales\"}', '/animales', 'acontecimientos', 'administrator', 'd7518474-2d2f-4634-823f-71936565c110', 0, 0, '2025-11-20 17:48:33', 'd7518474-2d2f-4634-823f-71936565c110', '2025-11-20 18:06:47', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL),
('649cee18-b495-4384-b80e-921aa1e0c5a5', 'acon_vacunacion_registrada', '{\"vacuna_nombre\":\"asd\",\"vacuna_fecha\":\"2025-11-20\",\"vacuna_dosis\":\"1\",\"detalle_animales\":\"1 animal\"}', '/animales', 'acontecimientos', 'administrator', 'd7518474-2d2f-4634-823f-71936565c110', 0, 0, '2025-11-20 17:36:20', 'd7518474-2d2f-4634-823f-71936565c110', '2025-11-20 18:06:47', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL),
('a0782007-c215-4a8d-a6b8-c799159b045b', 'acon_revision_registrada', '{\"revision_fecha\":\"2025-11-14\",\"revision_veterinario\":\"asd\",\"detalle_animales\":\"1 animal\"}', '/animales', 'acontecimientos', 'administrator', 'd7518474-2d2f-4634-823f-71936565c110', 0, 0, '2025-11-20 17:45:13', 'd7518474-2d2f-4634-823f-71936565c110', '2025-11-20 18:06:47', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL),
('a9e1686c-2100-45aa-8a97-26836b29d39b', 'acon_cuarentena_inicio', '{\"cuarentena_inicio\":\"2025-11-14\",\"cuarentena_fin\":\"2025-11-16\",\"cuarentena_motivo\":\"Gripe porcina\",\"detalle_animales\":\"1 animal\"}', '/animales/salud', 'acontecimientos', 'administrator', 'd7518474-2d2f-4634-823f-71936565c110', 0, 0, '2025-11-14 11:30:08', 'd7518474-2d2f-4634-823f-71936565c110', '2025-11-14 11:30:13', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL),
('cb74c02b-2204-4d6b-9ebb-6a0c4909e3ce', 'acon_vacunacion_registrada', '{\"vacuna_nombre\":\"fsa\",\"vacuna_fecha\":\"2025-11-14\",\"vacuna_dosis\":\"2\",\"detalle_animales\":\"1 animal\"}', '/animales/salud', 'acontecimientos', 'administrator', '202b02fa-053d-48d5-a307-b52adb5525f4', 0, 0, '2025-11-14 11:26:12', '202b02fa-053d-48d5-a307-b52adb5525f4', '2025-11-14 11:27:31', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL),
('dac1479a-fd05-4922-a4e5-f1efaf9ecf65', 'acon_cuarentena_inicio', '{\"cuarentena_inicio\":\"2025-11-14\",\"cuarentena_fin\":\"2025-11-16\",\"cuarentena_motivo\":\"Gripe porcina\",\"detalle_animales\":\"1 animal\"}', '/animales/salud', 'acontecimientos', 'administrator', 'd7518474-2d2f-4634-823f-71936565c110', 0, 0, '2025-11-14 11:31:37', 'd7518474-2d2f-4634-823f-71936565c110', '2025-11-14 11:31:40', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL),
('f436f413-0d4d-416f-b65f-5805f87cae54', 'acon_vacunacion_registrada', '{\"vacuna_nombre\":\"fsa\",\"vacuna_fecha\":\"2025-11-14\",\"vacuna_dosis\":\"2\",\"detalle_animales\":\"1 animal\"}', '/animales/salud', 'acontecimientos', 'administrator', '202b02fa-053d-48d5-a307-b52adb5525f4', 0, 0, '2025-11-14 11:27:24', '202b02fa-053d-48d5-a307-b52adb5525f4', '2025-11-14 11:27:31', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `partos`
--

CREATE TABLE `partos` (
  `parto_id` char(36) NOT NULL,
  `periodo_id` char(36) NOT NULL,
  `fecha_parto` date NOT NULL,
  `crias_machos` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `crias_hembras` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `peso_promedio_kg` decimal(5,2) DEFAULT NULL,
  `estado_parto` enum('NORMAL','DISTOCIA','MUERTE_PERINATAL','OTRO') NOT NULL DEFAULT 'NORMAL',
  `observaciones` varchar(255) DEFAULT NULL,
  `fotografia_url` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` char(36) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `partos`
--

INSERT INTO `partos` (`parto_id`, `periodo_id`, `fecha_parto`, `crias_machos`, `crias_hembras`, `peso_promedio_kg`, `estado_parto`, `observaciones`, `fotografia_url`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('2adba12c-538a-4452-b907-ffe9d2c72f8e', '2efa8a7b-4fce-40c9-b71a-0e6af178df9f', '2025-10-07', 1, 1, 3.60, 'DISTOCIA', 'Parto actualizado (test)', NULL, '2025-10-07 10:48:36', 'd7518474-2d2f-4634-823f-71936565c110', '2025-10-07 10:48:36', 'd7518474-2d2f-4634-823f-71936565c110', '2025-10-07 10:48:36', 'd7518474-2d2f-4634-823f-71936565c110'),
('44b8bebe-577d-4fa1-8d8d-aa61cbb87e08', 'ec12cdac-0816-4ec5-90cf-19249ea3b394', '2025-11-09', 10, 10, NULL, 'NORMAL', '', NULL, '2025-11-09 10:56:33', '202b02fa-053d-48d5-a307-b52adb5525f4', '2025-11-09 10:56:33', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL);

--
-- Disparadores `partos`
--
DELIMITER $$
CREATE TRIGGER `trg_partos_delete` BEFORE DELETE ON `partos` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'partos', OLD.parto_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'parto_id', OLD.parto_id,
      'periodo_id', OLD.periodo_id,
      'fecha_parto', OLD.fecha_parto,
      'crias_machos', OLD.crias_machos,
      'crias_hembras', OLD.crias_hembras,
      'peso_promedio_kg', OLD.peso_promedio_kg,
      'estado_parto', OLD.estado_parto,
      'observaciones', OLD.observaciones,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_partos_delete_logical` AFTER UPDATE ON `partos` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'partos', OLD.parto_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'parto_id', OLD.parto_id,
        'periodo_id', OLD.periodo_id,
        'fecha_parto', OLD.fecha_parto,
        'crias_machos', OLD.crias_machos,
        'crias_hembras', OLD.crias_hembras,
        'peso_promedio_kg', OLD.peso_promedio_kg,
        'estado_parto', OLD.estado_parto,
        'observaciones', OLD.observaciones,
        'created_at', OLD.created_at,
        'created_by', OLD.created_by,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_partos_insert` AFTER INSERT ON `partos` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'partos', NEW.parto_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'parto_id', NEW.parto_id,
      'periodo_id', NEW.periodo_id,
      'fecha_parto', NEW.fecha_parto,
      'crias_machos', NEW.crias_machos,
      'crias_hembras', NEW.crias_hembras,
      'peso_promedio_kg', NEW.peso_promedio_kg,
      'estado_parto', NEW.estado_parto,
      'observaciones', NEW.observaciones,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_partos_update` AFTER UPDATE ON `partos` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.periodo_id <> NEW.periodo_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"periodo_id":{"old":"', escape_json(OLD.periodo_id), '","new":"', escape_json(NEW.periodo_id), '"}');
  END IF;
  IF OLD.fecha_parto <> NEW.fecha_parto THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"fecha_parto":{"old":"', escape_json(OLD.fecha_parto), '","new":"', escape_json(NEW.fecha_parto), '"}');
  END IF;
  IF OLD.crias_machos <> NEW.crias_machos THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"crias_machos":{"old":"', escape_json(OLD.crias_machos), '","new":"', escape_json(NEW.crias_machos), '"}');
  END IF;
  IF OLD.crias_hembras <> NEW.crias_hembras THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"crias_hembras":{"old":"', escape_json(OLD.crias_hembras), '","new":"', escape_json(NEW.crias_hembras), '"}');
  END IF;
  IF OLD.peso_promedio_kg <> NEW.peso_promedio_kg THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"peso_promedio_kg":{"old":"', escape_json(OLD.peso_promedio_kg), '","new":"', escape_json(NEW.peso_promedio_kg), '"}');
  END IF;
  IF OLD.estado_parto <> NEW.estado_parto THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"estado_parto":{"old":"', escape_json(OLD.estado_parto), '","new":"', escape_json(NEW.estado_parto), '"}');
  END IF;
  IF OLD.observaciones <> NEW.observaciones THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"observaciones":{"old":"', escape_json(OLD.observaciones), '","new":"', escape_json(NEW.observaciones), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'partos', OLD.parto_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `password_resets`
--

CREATE TABLE `password_resets` (
  `password_reset_id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `periodos_servicio`
--

CREATE TABLE `periodos_servicio` (
  `periodo_id` char(36) NOT NULL,
  `hembra_id` char(36) NOT NULL,
  `verraco_id` char(36) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `hora_servicio` time DEFAULT NULL,
  `frecuencia_servicios` enum('diaria','cada_2_dias','cada_3_dias','cada_4_dias','cada_5_dias') DEFAULT 'diaria',
  `numero_servicios` int(11) NOT NULL DEFAULT 3,
  `observaciones` varchar(255) DEFAULT NULL,
  `estado_periodo` enum('ABIERTO','CERRADO') NOT NULL DEFAULT 'ABIERTO',
  `created_at` datetime DEFAULT NULL,
  `created_by` char(36) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `periodos_servicio`
--

INSERT INTO `periodos_servicio` (`periodo_id`, `hembra_id`, `verraco_id`, `fecha_inicio`, `hora_servicio`, `frecuencia_servicios`, `numero_servicios`, `observaciones`, `estado_periodo`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('220d5f3b-2cd3-404a-ba77-dd0e8f821ac3', 'l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', 'k12c3441-b7f6-4af3-8a9e-43df2b28aee7', '2025-11-09', '12:49:00', 'diaria', 1, '', 'CERRADO', '2025-11-09 16:49:18', '202b02fa-053d-48d5-a307-b52adb5525f4', '2025-11-09 12:50:04', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL),
('4e7cb250-c176-4ad0-b13e-af0544df7d89', 's90d1b25-1f83-4e74-a730-fb94fca8f9a5', 'ab29db65-86d8-46c6-bc47-85a988176e4a', '2025-11-01', '10:47:00', 'diaria', 5, 'fassfa', 'CERRADO', '2025-11-17 15:47:17', '202b02fa-053d-48d5-a307-b52adb5525f4', '2025-11-17 10:49:55', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL),
('752433b6-70fd-41f4-a5b4-72d055b121e4', 's90d1b25-1f83-4e74-a730-fb94fca8f9a5', 'ab29db65-86d8-46c6-bc47-85a988176e4a', '2025-10-23', '10:30:00', 'diaria', 3, '', 'CERRADO', '2025-10-23 21:03:28', 'd7518474-2d2f-4634-823f-71936565c110', '2025-11-09 12:52:03', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL),
('7b222c37-bc28-43be-921a-d1c9539c45ab', 'l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', 'k12c3441-b7f6-4af3-8a9e-43df2b28aee7', '2025-11-09', '12:52:00', 'diaria', 5, '', 'CERRADO', '2025-11-09 16:52:47', '202b02fa-053d-48d5-a307-b52adb5525f4', '2025-11-09 12:55:43', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL),
('d1ed07a3-a564-4174-a7bb-7c31b1d573c3', 'l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', 'k12c3441-b7f6-4af3-8a9e-43df2b28aee7', '2025-11-09', '12:51:00', 'diaria', 5, '', 'CERRADO', '2025-11-09 16:51:08', '202b02fa-053d-48d5-a307-b52adb5525f4', '2025-11-09 12:51:28', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL),
('ec12cdac-0816-4ec5-90cf-19249ea3b394', 'l23db3a2-93e3-4e3d-97e5-b78e1dfd2aa0', 'ab29db65-86d8-46c6-bc47-85a988176e4a', '2025-10-30', '11:16:00', 'diaria', 3, 'nose', 'CERRADO', '2025-10-30 16:16:19', '202b02fa-053d-48d5-a307-b52adb5525f4', '2025-10-30 11:45:54', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL);

--
-- Disparadores `periodos_servicio`
--
DELIMITER $$
CREATE TRIGGER `trg_periodos_servicio_delete` BEFORE DELETE ON `periodos_servicio` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'periodos_servicio', OLD.periodo_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'periodo_id', OLD.periodo_id,
      'hembra_id', OLD.hembra_id,
      'verraco_id', OLD.verraco_id,
      'fecha_inicio', OLD.fecha_inicio,
      'hora_servicio', OLD.hora_servicio,
      'frecuencia_servicios', OLD.frecuencia_servicios,
      'numero_servicios', OLD.numero_servicios,
      'observaciones', OLD.observaciones,
      'estado_periodo', OLD.estado_periodo,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_periodos_servicio_delete_logical` AFTER UPDATE ON `periodos_servicio` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'periodos_servicio', OLD.periodo_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'periodo_id', OLD.periodo_id,
        'hembra_id', OLD.hembra_id,
        'verraco_id', OLD.verraco_id,
        'fecha_inicio', OLD.fecha_inicio,
        'hora_servicio', OLD.hora_servicio,
        'frecuencia_servicios', OLD.frecuencia_servicios,
        'numero_servicios', OLD.numero_servicios,
        'observaciones', OLD.observaciones,
        'estado_periodo', OLD.estado_periodo,
        'created_at', OLD.created_at,
        'created_by', OLD.created_by,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_periodos_servicio_insert` AFTER INSERT ON `periodos_servicio` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'periodos_servicio', NEW.periodo_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'periodo_id', NEW.periodo_id,
      'hembra_id', NEW.hembra_id,
      'verraco_id', NEW.verraco_id,
      'fecha_inicio', NEW.fecha_inicio,
      'hora_servicio', NEW.hora_servicio,
      'frecuencia_servicios', NEW.frecuencia_servicios,
      'numero_servicios', NEW.numero_servicios,
      'observaciones', NEW.observaciones,
      'estado_periodo', NEW.estado_periodo,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_periodos_servicio_update` AFTER UPDATE ON `periodos_servicio` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.hembra_id <> NEW.hembra_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"hembra_id":{"old":"', escape_json(OLD.hembra_id), '","new":"', escape_json(NEW.hembra_id), '"}');
  END IF;
  IF OLD.verraco_id <> NEW.verraco_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"verraco_id":{"old":"', escape_json(OLD.verraco_id), '","new":"', escape_json(NEW.verraco_id), '"}');
  END IF;
  IF OLD.fecha_inicio <> NEW.fecha_inicio THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"fecha_inicio":{"old":"', escape_json(OLD.fecha_inicio), '","new":"', escape_json(NEW.fecha_inicio), '"}');
  END IF;
  IF OLD.hora_servicio <> NEW.hora_servicio THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"hora_servicio":{"old":"', escape_json(OLD.hora_servicio), '","new":"', escape_json(NEW.hora_servicio), '"}');
  END IF;
  IF OLD.frecuencia_servicios <> NEW.frecuencia_servicios THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"frecuencia_servicios":{"old":"', escape_json(OLD.frecuencia_servicios), '","new":"', escape_json(NEW.frecuencia_servicios), '"}');
  END IF;
  IF OLD.numero_servicios <> NEW.numero_servicios THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"numero_servicios":{"old":"', escape_json(OLD.numero_servicios), '","new":"', escape_json(NEW.numero_servicios), '"}');
  END IF;
  IF OLD.observaciones <> NEW.observaciones THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"observaciones":{"old":"', escape_json(OLD.observaciones), '","new":"', escape_json(NEW.observaciones), '"}');
  END IF;
  IF OLD.estado_periodo <> NEW.estado_periodo THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"estado_periodo":{"old":"', escape_json(OLD.estado_periodo), '","new":"', escape_json(NEW.estado_periodo), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'periodos_servicio', OLD.periodo_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `razas`
--

CREATE TABLE `razas` (
  `raza_id` char(36) NOT NULL,
  `especie` enum('BOVINO','OVINO','CAPRINO','PORCINO','OTRO') NOT NULL DEFAULT 'PORCINO',
  `codigo` varchar(40) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `estado` enum('ACTIVA','INACTIVA') NOT NULL DEFAULT 'ACTIVA',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by` char(36) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `razas`
--

INSERT INTO `razas` (`raza_id`, `especie`, `codigo`, `nombre`, `descripcion`, `estado`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('11111111-1111-1111-1111-111111111111', 'PORCINO', 'YORK', 'Yorkshire (Large White)', 'Raza materna de alta prolificidad', 'ACTIVA', '2025-10-22 10:46:33', NULL, NULL, NULL, NULL, NULL),
('22222222-2222-2222-2222-222222222222', 'PORCINO', 'LAND', 'Landrace', 'Materna, buena aptitud lechera', 'ACTIVA', '2025-10-22 10:46:33', NULL, NULL, NULL, NULL, NULL),
('33333333-3333-3333-3333-333333333333', 'PORCINO', 'DURO', 'Duroc', 'Cárnica, crecimiento eficiente', 'ACTIVA', '2025-10-22 10:46:33', NULL, NULL, NULL, NULL, NULL),
('44444444-4444-4444-4444-444444444444', 'PORCINO', 'PIET', 'Pietrain', 'Cárnica, alto porcentaje magro', 'ACTIVA', '2025-10-22 10:46:33', NULL, NULL, NULL, NULL, NULL),
('55555555-5555-5555-5555-555555555555', 'PORCINO', 'HAMP', 'Hampshire', 'Cárnica, rusticidad', 'ACTIVA', '2025-10-22 10:46:33', NULL, NULL, NULL, NULL, NULL),
('66666666-6666-6666-6666-666666666666', 'PORCINO', 'BERK', 'Berkshire', 'Carne marmoleada, buena calidad', 'ACTIVA', '2025-10-22 10:46:33', NULL, NULL, NULL, NULL, NULL),
('77777777-7777-7777-7777-777777777777', 'PORCINO', 'CHEW', 'Chester White', 'Materna, rusticidad media', 'ACTIVA', '2025-10-22 10:46:33', NULL, NULL, NULL, NULL, NULL),
('88888888-8888-8888-8888-888888888888', 'PORCINO', 'POLC', 'Poland China', 'Crecimiento y conformación', 'ACTIVA', '2025-10-22 10:46:33', NULL, NULL, NULL, NULL, NULL),
('99999999-9999-9999-9999-999999999999', 'PORCINO', 'SPOT', 'Spotted', 'Ganancia moderada, rusticidad', 'ACTIVA', '2025-10-22 10:46:33', NULL, NULL, NULL, NULL, NULL),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'PORCINO', 'TAMW', 'Tamworth', 'Rústica, forrajera', 'ACTIVA', '2025-10-22 10:46:33', NULL, NULL, NULL, NULL, NULL),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'PORCINO', 'HERE', 'Hereford', 'Conformación y docilidad', 'ACTIVA', '2025-10-22 10:46:33', NULL, NULL, NULL, NULL, NULL),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'PORCINO', 'LBLK', 'Large Black', 'Rústica, pastoreo', 'ACTIVA', '2025-10-22 10:46:33', NULL, NULL, NULL, NULL, NULL),
('dddddddd-dddd-dddd-dddd-dddddddddddd', 'PORCINO', 'CRIO', 'Criollo', 'Adaptada a condiciones locales', 'ACTIVA', '2025-10-22 10:46:33', NULL, NULL, NULL, NULL, NULL);

--
-- Disparadores `razas`
--
DELIMITER $$
CREATE TRIGGER `trg_razas_delete` BEFORE DELETE ON `razas` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'razas', OLD.raza_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'raza_id', OLD.raza_id,
      'especie', OLD.especie,
      'codigo', OLD.codigo,
      'nombre', OLD.nombre,
      'descripcion', OLD.descripcion,
      'estado', OLD.estado,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_razas_delete_logical` AFTER UPDATE ON `razas` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'razas', OLD.raza_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'raza_id', OLD.raza_id,
        'especie', OLD.especie,
        'codigo', OLD.codigo,
        'nombre', OLD.nombre,
        'descripcion', OLD.descripcion,
        'estado', OLD.estado,
        'created_at', OLD.created_at,
        'created_by', OLD.created_by,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_razas_insert` AFTER INSERT ON `razas` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'razas', NEW.raza_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'raza_id', NEW.raza_id,
      'especie', NEW.especie,
      'codigo', NEW.codigo,
      'nombre', NEW.nombre,
      'descripcion', NEW.descripcion,
      'estado', NEW.estado,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_razas_update` AFTER UPDATE ON `razas` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.especie <> NEW.especie THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"especie":{"old":"', escape_json(OLD.especie), '","new":"', escape_json(NEW.especie), '"}');
  END IF;
  IF OLD.codigo <> NEW.codigo THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"codigo":{"old":"', escape_json(OLD.codigo), '","new":"', escape_json(NEW.codigo), '"}');
  END IF;
  IF OLD.nombre <> NEW.nombre THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"nombre":{"old":"', escape_json(OLD.nombre), '","new":"', escape_json(NEW.nombre), '"}');
  END IF;
  IF OLD.descripcion <> NEW.descripcion THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"descripcion":{"old":"', escape_json(OLD.descripcion), '","new":"', escape_json(NEW.descripcion), '"}');
  END IF;
  IF OLD.estado <> NEW.estado THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"estado":{"old":"', escape_json(OLD.estado), '","new":"', escape_json(NEW.estado), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'razas', OLD.raza_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recintos`
--

CREATE TABLE `recintos` (
  `recinto_id` char(36) NOT NULL,
  `area_id` char(36) NOT NULL,
  `codigo_recinto` varchar(50) NOT NULL,
  `capacidad` smallint(5) UNSIGNED DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
  `observaciones` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by` char(36) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `recintos`
--

INSERT INTO `recintos` (`recinto_id`, `area_id`, `codigo_recinto`, `capacidad`, `estado`, `observaciones`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('66de25f3-a5a7-4616-8148-7ce4513e4f04', '9927c9e7-d35a-4b1c-93b0-c078894cc9ef', 'rec_01', 100, 'ACTIVO', NULL, '2025-11-09 10:55:55', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL);

--
-- Disparadores `recintos`
--
DELIMITER $$
CREATE TRIGGER `trg_recintos_delete` BEFORE DELETE ON `recintos` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'recintos', OLD.recinto_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'recinto_id', OLD.recinto_id,
      'area_id', OLD.area_id,
      'codigo_recinto', OLD.codigo_recinto,
      'capacidad', OLD.capacidad,
      'estado', OLD.estado,
      'observaciones', OLD.observaciones,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_recintos_delete_logical` AFTER UPDATE ON `recintos` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'recintos', OLD.recinto_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'recinto_id', OLD.recinto_id,
        'area_id', OLD.area_id,
        'codigo_recinto', OLD.codigo_recinto,
        'capacidad', OLD.capacidad,
        'estado', OLD.estado,
        'observaciones', OLD.observaciones,
        'created_at', OLD.created_at,
        'created_by', OLD.created_by,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_recintos_insert` AFTER INSERT ON `recintos` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'recintos', NEW.recinto_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'recinto_id', NEW.recinto_id,
      'area_id', NEW.area_id,
      'codigo_recinto', NEW.codigo_recinto,
      'capacidad', NEW.capacidad,
      'estado', NEW.estado,
      'observaciones', NEW.observaciones,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_recintos_update` AFTER UPDATE ON `recintos` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.area_id <> NEW.area_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"area_id":{"old":"', escape_json(OLD.area_id), '","new":"', escape_json(NEW.area_id), '"}');
  END IF;
  IF OLD.codigo_recinto <> NEW.codigo_recinto THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"codigo_recinto":{"old":"', escape_json(OLD.codigo_recinto), '","new":"', escape_json(NEW.codigo_recinto), '"}');
  END IF;
  IF OLD.capacidad <> NEW.capacidad THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"capacidad":{"old":"', escape_json(OLD.capacidad), '","new":"', escape_json(NEW.capacidad), '"}');
  END IF;
  IF OLD.estado <> NEW.estado THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"estado":{"old":"', escape_json(OLD.estado), '","new":"', escape_json(NEW.estado), '"}');
  END IF;
  IF OLD.observaciones <> NEW.observaciones THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"observaciones":{"old":"', escape_json(OLD.observaciones), '","new":"', escape_json(NEW.observaciones), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'recintos', OLD.recinto_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reportes_dano`
--

CREATE TABLE `reportes_dano` (
  `reporte_id` char(36) NOT NULL,
  `finca_id` char(36) DEFAULT NULL,
  `aprisco_id` char(36) DEFAULT NULL,
  `area_id` char(36) DEFAULT NULL,
  `titulo` varchar(150) NOT NULL,
  `descripcion` text NOT NULL,
  `criticidad` enum('BAJA','MEDIA','ALTA') NOT NULL DEFAULT 'BAJA',
  `estado_reporte` enum('ABIERTO','EN_PROCESO','CERRADO') NOT NULL DEFAULT 'ABIERTO',
  `fecha_reporte` datetime NOT NULL DEFAULT current_timestamp(),
  `reportado_por` char(36) DEFAULT NULL,
  `solucionado_por` char(36) DEFAULT NULL,
  `fecha_cierre` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` char(36) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `reportes_dano`
--

INSERT INTO `reportes_dano` (`reporte_id`, `finca_id`, `aprisco_id`, `area_id`, `titulo`, `descripcion`, `criticidad`, `estado_reporte`, `fecha_reporte`, `reportado_por`, `solucionado_por`, `fecha_cierre`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('def09c3d-e0e5-48a3-b53a-8953f724a6d9', '06fcbfc8-ffc7-4956-b99d-77d879d772b7', '78059699-0f15-419e-89a8-fcc2697c4c97', '9927c9e7-d35a-4b1c-93b0-c078894cc9ef', 'Daño en bebedero rd20er', 'Fuga intermitente; requiere cambio de manguera.', 'ALTA', 'EN_PROCESO', '2025-10-02 10:52:17', NULL, NULL, '2025-10-02 10:52:17', '2025-10-02 10:52:17', 'def09c3d-e0e5-48a3-b53a-8953f724a6d9', '2025-10-05 19:52:21', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL);

--
-- Disparadores `reportes_dano`
--
DELIMITER $$
CREATE TRIGGER `trg_reportes_dano_delete` BEFORE DELETE ON `reportes_dano` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'reportes_dano', OLD.reporte_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'reporte_id', OLD.reporte_id,
      'finca_id', OLD.finca_id,
      'aprisco_id', OLD.aprisco_id,
      'area_id', OLD.area_id,
      'titulo', OLD.titulo,
      'descripcion', OLD.descripcion,
      'criticidad', OLD.criticidad,
      'estado_reporte', OLD.estado_reporte,
      'fecha_reporte', OLD.fecha_reporte,
      'reportado_por', OLD.reportado_por,
      'solucionado_por', OLD.solucionado_por,
      'fecha_cierre', OLD.fecha_cierre,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_reportes_dano_delete_logical` AFTER UPDATE ON `reportes_dano` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'reportes_dano', OLD.reporte_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'reporte_id', OLD.reporte_id,
        'finca_id', OLD.finca_id,
        'aprisco_id', OLD.aprisco_id,
        'area_id', OLD.area_id,
        'titulo', OLD.titulo,
        'descripcion', OLD.descripcion,
        'criticidad', OLD.criticidad,
        'estado_reporte', OLD.estado_reporte,
        'fecha_reporte', OLD.fecha_reporte,
        'reportado_por', OLD.reportado_por,
        'solucionado_por', OLD.solucionado_por,
        'fecha_cierre', OLD.fecha_cierre,
        'created_at', OLD.created_at,
        'created_by', OLD.created_by,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_reportes_dano_insert` AFTER INSERT ON `reportes_dano` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'reportes_dano', NEW.reporte_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'reporte_id', NEW.reporte_id,
      'finca_id', NEW.finca_id,
      'aprisco_id', NEW.aprisco_id,
      'area_id', NEW.area_id,
      'titulo', NEW.titulo,
      'descripcion', NEW.descripcion,
      'criticidad', NEW.criticidad,
      'estado_reporte', NEW.estado_reporte,
      'fecha_reporte', NEW.fecha_reporte,
      'reportado_por', NEW.reportado_por,
      'solucionado_por', NEW.solucionado_por,
      'fecha_cierre', NEW.fecha_cierre,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_reportes_dano_update` AFTER UPDATE ON `reportes_dano` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.finca_id <> NEW.finca_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"finca_id":{"old":"', escape_json(OLD.finca_id), '","new":"', escape_json(NEW.finca_id), '"}');
  END IF;
  IF OLD.aprisco_id <> NEW.aprisco_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"aprisco_id":{"old":"', escape_json(OLD.aprisco_id), '","new":"', escape_json(NEW.aprisco_id), '"}');
  END IF;
  IF OLD.area_id <> NEW.area_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"area_id":{"old":"', escape_json(OLD.area_id), '","new":"', escape_json(NEW.area_id), '"}');
  END IF;
  IF OLD.titulo <> NEW.titulo THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"titulo":{"old":"', escape_json(OLD.titulo), '","new":"', escape_json(NEW.titulo), '"}');
  END IF;
  IF OLD.descripcion <> NEW.descripcion THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"descripcion":{"old":"', escape_json(OLD.descripcion), '","new":"', escape_json(NEW.descripcion), '"}');
  END IF;
  IF OLD.criticidad <> NEW.criticidad THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"criticidad":{"old":"', escape_json(OLD.criticidad), '","new":"', escape_json(NEW.criticidad), '"}');
  END IF;
  IF OLD.estado_reporte <> NEW.estado_reporte THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"estado_reporte":{"old":"', escape_json(OLD.estado_reporte), '","new":"', escape_json(NEW.estado_reporte), '"}');
  END IF;
  IF OLD.fecha_reporte <> NEW.fecha_reporte THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"fecha_reporte":{"old":"', escape_json(OLD.fecha_reporte), '","new":"', escape_json(NEW.fecha_reporte), '"}');
  END IF;
  IF OLD.reportado_por <> NEW.reportado_por THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"reportado_por":{"old":"', escape_json(OLD.reportado_por), '","new":"', escape_json(NEW.reportado_por), '"}');
  END IF;
  IF OLD.solucionado_por <> NEW.solucionado_por THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"solucionado_por":{"old":"', escape_json(OLD.solucionado_por), '","new":"', escape_json(NEW.solucionado_por), '"}');
  END IF;
  IF OLD.fecha_cierre <> NEW.fecha_cierre THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"fecha_cierre":{"old":"', escape_json(OLD.fecha_cierre), '","new":"', escape_json(NEW.fecha_cierre), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'reportes_dano', OLD.reporte_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `revisiones_servicio`
--

CREATE TABLE `revisiones_servicio` (
  `revision_id` char(36) NOT NULL,
  `periodo_id` char(36) NOT NULL,
  `ciclo_control` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `fecha_programada` date NOT NULL,
  `fecha_realizada` date DEFAULT NULL,
  `resultado` enum('ENTRO_EN_CELO','SOSPECHA_PREÑEZ','CONFIRMADA_PREÑEZ','SIN_SEÑALES') DEFAULT NULL,
  `observaciones` varchar(255) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `revisiones_servicio`
--

INSERT INTO `revisiones_servicio` (`revision_id`, `periodo_id`, `ciclo_control`, `fecha_programada`, `fecha_realizada`, `resultado`, `observaciones`, `created_by`, `created_at`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('0d563d0e-cdd1-4a12-abd7-f1ad724a9988', '7b222c37-bc28-43be-921a-d1c9539c45ab', 3, '2026-01-11', '2025-11-09', 'CONFIRMADA_PREÑEZ', '', '202b02fa-053d-48d5-a307-b52adb5525f4', '2025-11-09 12:52:50', '2025-11-09 12:55:43', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL),
('3339bfbe-301c-475b-905e-348e5b7bcd7f', 'd1ed07a3-a564-4174-a7bb-7c31b1d573c3', 1, '2025-11-30', '2025-11-09', 'ENTRO_EN_CELO', '', '202b02fa-053d-48d5-a307-b52adb5525f4', '2025-11-09 12:51:11', '2025-11-09 12:51:28', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL),
('703c41eb-98df-4185-8065-f5d1c3288b07', '220d5f3b-2cd3-404a-ba77-dd0e8f821ac3', 1, '2025-11-30', '2025-11-09', 'ENTRO_EN_CELO', '', '202b02fa-053d-48d5-a307-b52adb5525f4', '2025-11-09 12:49:26', '2025-11-09 12:50:04', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL),
('7a133f8e-bbed-4eac-b52f-d2bd16b3be2b', '4e7cb250-c176-4ad0-b13e-af0544df7d89', 1, '2025-11-22', '2025-11-17', 'CONFIRMADA_PREÑEZ', 'fasfsa', '202b02fa-053d-48d5-a307-b52adb5525f4', '2025-11-17 10:47:22', '2025-11-17 10:49:55', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL),
('9331dbdd-80d5-4f0c-8096-aae0443b3385', 'ec12cdac-0816-4ec5-90cf-19249ea3b394', 3, '2026-01-01', '2025-10-30', 'CONFIRMADA_PREÑEZ', 'fsafsafa', '202b02fa-053d-48d5-a307-b52adb5525f4', '2025-10-30 11:17:55', '2025-10-30 11:45:54', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL),
('c25f49ca-dee5-48d4-89c5-81674a70933c', '752433b6-70fd-41f4-a5b4-72d055b121e4', 2, '2025-12-04', '2025-11-09', 'ENTRO_EN_CELO', '', 'd7518474-2d2f-4634-823f-71936565c110', '2025-10-23 15:03:41', '2025-11-09 12:52:03', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL);

--
-- Disparadores `revisiones_servicio`
--
DELIMITER $$
CREATE TRIGGER `trg_revisiones_servicio_delete` BEFORE DELETE ON `revisiones_servicio` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'revisiones_servicio', OLD.revision_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'revision_id', OLD.revision_id,
      'periodo_id', OLD.periodo_id,
      'ciclo_control', OLD.ciclo_control,
      'fecha_programada', OLD.fecha_programada,
      'fecha_realizada', OLD.fecha_realizada,
      'resultado', OLD.resultado,
      'observaciones', OLD.observaciones,
      'created_by', OLD.created_by,
      'created_at', OLD.created_at,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_revisiones_servicio_delete_logical` AFTER UPDATE ON `revisiones_servicio` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'revisiones_servicio', OLD.revision_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'revision_id', OLD.revision_id,
        'periodo_id', OLD.periodo_id,
        'ciclo_control', OLD.ciclo_control,
        'fecha_programada', OLD.fecha_programada,
        'fecha_realizada', OLD.fecha_realizada,
        'resultado', OLD.resultado,
        'observaciones', OLD.observaciones,
        'created_by', OLD.created_by,
        'created_at', OLD.created_at,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_revisiones_servicio_insert` AFTER INSERT ON `revisiones_servicio` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'revisiones_servicio', NEW.revision_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'revision_id', NEW.revision_id,
      'periodo_id', NEW.periodo_id,
      'ciclo_control', NEW.ciclo_control,
      'fecha_programada', NEW.fecha_programada,
      'fecha_realizada', NEW.fecha_realizada,
      'resultado', NEW.resultado,
      'observaciones', NEW.observaciones,
      'created_by', NEW.created_by,
      'created_at', NEW.created_at
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_revisiones_servicio_update` AFTER UPDATE ON `revisiones_servicio` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.periodo_id <> NEW.periodo_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"periodo_id":{"old":"', escape_json(OLD.periodo_id), '","new":"', escape_json(NEW.periodo_id), '"}');
  END IF;
  IF OLD.ciclo_control <> NEW.ciclo_control THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"ciclo_control":{"old":"', escape_json(OLD.ciclo_control), '","new":"', escape_json(NEW.ciclo_control), '"}');
  END IF;
  IF OLD.fecha_programada <> NEW.fecha_programada THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"fecha_programada":{"old":"', escape_json(OLD.fecha_programada), '","new":"', escape_json(NEW.fecha_programada), '"}');
  END IF;
  IF OLD.fecha_realizada <> NEW.fecha_realizada THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"fecha_realizada":{"old":"', escape_json(OLD.fecha_realizada), '","new":"', escape_json(NEW.fecha_realizada), '"}');
  END IF;
  IF OLD.resultado <> NEW.resultado THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"resultado":{"old":"', escape_json(OLD.resultado), '","new":"', escape_json(NEW.resultado), '"}');
  END IF;
  IF OLD.observaciones <> NEW.observaciones THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"observaciones":{"old":"', escape_json(OLD.observaciones), '","new":"', escape_json(NEW.observaciones), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'revisiones_servicio', OLD.revision_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `saneamiento_areas`
--

CREATE TABLE `saneamiento_areas` (
  `saneamiento_areas_id` char(36) NOT NULL,
  `area_id` char(36) NOT NULL,
  `fecha` date NOT NULL DEFAULT current_timestamp(),
  `foto` varchar(100) DEFAULT NULL,
  `observacion` varchar(255) DEFAULT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `create_by` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicios`
--

CREATE TABLE `servicios` (
  `monta_id` char(36) NOT NULL,
  `periodo_id` char(36) NOT NULL,
  `numero_monta` tinyint(3) UNSIGNED NOT NULL,
  `fecha_monta` datetime NOT NULL,
  `estatus` enum('PENDIENTE','REALIZADO') NOT NULL DEFAULT 'PENDIENTE',
  `created_at` datetime DEFAULT NULL,
  `created_by` char(36) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `servicios`
--

INSERT INTO `servicios` (`monta_id`, `periodo_id`, `numero_monta`, `fecha_monta`, `estatus`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('10a730f7-a961-48f9-9804-5bd8ea255a4b', 'ec12cdac-0816-4ec5-90cf-19249ea3b394', 1, '2025-10-31 11:16:00', 'REALIZADO', '2025-10-30 16:16:19', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('11884304-8c96-4936-a87f-0e478315a313', '220d5f3b-2cd3-404a-ba77-dd0e8f821ac3', 1, '2025-11-10 12:49:00', 'REALIZADO', '2025-11-09 16:49:18', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('2a3415e5-4303-40f1-b6f1-2f4717aed08c', 'd1ed07a3-a564-4174-a7bb-7c31b1d573c3', 2, '2025-11-11 12:51:00', 'REALIZADO', '2025-11-09 16:51:08', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('3475d8c4-a9e9-42a4-9dd3-a77e41a1e26a', '752433b6-70fd-41f4-a5b4-72d055b121e4', 3, '2025-10-26 10:30:00', 'REALIZADO', '2025-10-23 21:03:28', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('4c2ff4e1-95f9-453f-9bd8-e918787a540d', '7b222c37-bc28-43be-921a-d1c9539c45ab', 1, '2025-11-10 12:52:00', 'REALIZADO', '2025-11-09 16:52:47', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('5b9bcaf0-c49a-4e39-b489-47abf3d49667', 'd1ed07a3-a564-4174-a7bb-7c31b1d573c3', 5, '2025-11-14 12:51:00', 'REALIZADO', '2025-11-09 16:51:08', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('7e09266f-e4ee-4c43-afdf-dbcd34a5c591', '7b222c37-bc28-43be-921a-d1c9539c45ab', 2, '2025-11-11 12:52:00', 'REALIZADO', '2025-11-09 16:52:47', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('807b15ef-793f-422f-bf45-5b5d42a3e6e6', 'ec12cdac-0816-4ec5-90cf-19249ea3b394', 2, '2025-11-01 11:16:00', 'REALIZADO', '2025-10-30 16:16:19', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('8e5441d2-3d6b-4241-9b3a-8983a04f2632', '752433b6-70fd-41f4-a5b4-72d055b121e4', 2, '2025-10-25 10:30:00', 'REALIZADO', '2025-10-23 21:03:28', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('9409cb31-2f32-4f49-9120-444f6f0c6c5d', '7b222c37-bc28-43be-921a-d1c9539c45ab', 4, '2025-11-13 12:52:00', 'REALIZADO', '2025-11-09 16:52:47', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('95b38af2-f3bf-46d2-95d9-94db73fcfb3f', 'd1ed07a3-a564-4174-a7bb-7c31b1d573c3', 1, '2025-11-10 12:51:00', 'REALIZADO', '2025-11-09 16:51:08', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('9a8da6df-33bd-415c-b581-19fa758c7abd', '4e7cb250-c176-4ad0-b13e-af0544df7d89', 5, '2025-11-06 10:47:00', 'REALIZADO', '2025-11-17 15:47:17', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('9aeaf86b-a84e-4262-a0c6-8cfa05bf8d2d', '4e7cb250-c176-4ad0-b13e-af0544df7d89', 4, '2025-11-05 10:47:00', 'REALIZADO', '2025-11-17 15:47:17', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('a7250932-961a-481e-93d2-665e047892cf', 'ec12cdac-0816-4ec5-90cf-19249ea3b394', 3, '2025-11-02 11:16:00', 'REALIZADO', '2025-10-30 16:16:19', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('aa2501d8-d064-49f7-8467-eaf0ab71f498', '7b222c37-bc28-43be-921a-d1c9539c45ab', 5, '2025-11-14 12:52:00', 'REALIZADO', '2025-11-09 16:52:47', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('ad1c8cfd-22e3-4a17-8e57-940a8258c44f', '7b222c37-bc28-43be-921a-d1c9539c45ab', 3, '2025-11-12 12:52:00', 'REALIZADO', '2025-11-09 16:52:47', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('bab2fda2-f2db-4372-82ea-084193d22829', '4e7cb250-c176-4ad0-b13e-af0544df7d89', 3, '2025-11-04 10:47:00', 'REALIZADO', '2025-11-17 15:47:17', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('ca2da07e-a95d-4ef4-ad80-41107401862b', '4e7cb250-c176-4ad0-b13e-af0544df7d89', 2, '2025-11-03 10:47:00', 'REALIZADO', '2025-11-17 15:47:17', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('d2e0a875-2238-4329-89bd-16b11b6bcea0', 'd1ed07a3-a564-4174-a7bb-7c31b1d573c3', 3, '2025-11-12 12:51:00', 'REALIZADO', '2025-11-09 16:51:08', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('d571c78b-c6d3-4d2a-b998-20113ee624a7', 'd1ed07a3-a564-4174-a7bb-7c31b1d573c3', 4, '2025-11-13 12:51:00', 'REALIZADO', '2025-11-09 16:51:08', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('d76f564a-f9dd-49eb-89f7-e2c47fe1ab08', '4e7cb250-c176-4ad0-b13e-af0544df7d89', 1, '2025-11-02 10:47:00', 'REALIZADO', '2025-11-17 15:47:17', '202b02fa-053d-48d5-a307-b52adb5525f4', NULL, NULL, NULL, NULL),
('db10229e-ed13-4bb2-a88e-b2b11997855d', '752433b6-70fd-41f4-a5b4-72d055b121e4', 1, '2025-10-24 10:30:00', 'REALIZADO', '2025-10-23 21:03:28', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL);

--
-- Disparadores `servicios`
--
DELIMITER $$
CREATE TRIGGER `trg_servicios_delete` BEFORE DELETE ON `servicios` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'servicios', OLD.monta_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'monta_id', OLD.monta_id,
      'periodo_id', OLD.periodo_id,
      'numero_monta', OLD.numero_monta,
      'fecha_monta', OLD.fecha_monta,
      'estatus', OLD.estatus,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_servicios_delete_logical` AFTER UPDATE ON `servicios` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'servicios', OLD.monta_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'monta_id', OLD.monta_id,
        'periodo_id', OLD.periodo_id,
        'numero_monta', OLD.numero_monta,
        'fecha_monta', OLD.fecha_monta,
        'estatus', OLD.estatus,
        'created_at', OLD.created_at,
        'created_by', OLD.created_by,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_servicios_insert` AFTER INSERT ON `servicios` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'servicios', NEW.monta_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'monta_id', NEW.monta_id,
      'periodo_id', NEW.periodo_id,
      'numero_monta', NEW.numero_monta,
      'fecha_monta', NEW.fecha_monta,
      'estatus', NEW.estatus,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_servicios_update` AFTER UPDATE ON `servicios` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.periodo_id <> NEW.periodo_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"periodo_id":{"old":"', escape_json(OLD.periodo_id), '","new":"', escape_json(NEW.periodo_id), '"}');
  END IF;
  IF OLD.numero_monta <> NEW.numero_monta THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"numero_monta":{"old":"', escape_json(OLD.numero_monta), '","new":"', escape_json(NEW.numero_monta), '"}');
  END IF;
  IF OLD.fecha_monta <> NEW.fecha_monta THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"fecha_monta":{"old":"', escape_json(OLD.fecha_monta), '","new":"', escape_json(NEW.fecha_monta), '"}');
  END IF;
  IF OLD.estatus <> NEW.estatus THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"estatus":{"old":"', escape_json(OLD.estatus), '","new":"', escape_json(NEW.estatus), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'servicios', OLD.monta_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `session_config`
--

CREATE TABLE `session_config` (
  `config_id` int(11) NOT NULL,
  `timeout_minutes` int(11) NOT NULL DEFAULT 30,
  `allow_ip_change` tinyint(1) NOT NULL DEFAULT 0,
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `session_config`
--

INSERT INTO `session_config` (`config_id`, `timeout_minutes`, `allow_ip_change`, `updated_at`, `updated_by`) VALUES
(1, 15, 0, '2025-07-16 09:13:28', '3');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `session_management`
--

CREATE TABLE `session_management` (
  `session_id` char(36) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `user_type` enum('Administrator','User') NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `login_time` datetime NOT NULL,
  `logout_time` datetime DEFAULT NULL,
  `inactivity_duration` varchar(255) DEFAULT NULL,
  `login_success` tinyint(1) NOT NULL DEFAULT 1,
  `failure_reason` varchar(255) DEFAULT NULL,
  `session_status` enum('active','closed','expired','failed','kicked') NOT NULL DEFAULT 'active',
  `ip_address` varchar(45) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `zipcode` varchar(20) DEFAULT NULL,
  `coordinates` varchar(50) DEFAULT NULL,
  `hostname` varchar(100) DEFAULT NULL,
  `os` varchar(100) DEFAULT NULL,
  `browser` varchar(100) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `device_id` varchar(100) DEFAULT NULL,
  `device_type` tinyint(1) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `token_used` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `session_management`
--

INSERT INTO `session_management` (`session_id`, `user_id`, `user_name`, `user_type`, `full_name`, `login_time`, `logout_time`, `inactivity_duration`, `login_success`, `failure_reason`, `session_status`, `ip_address`, `city`, `region`, `country`, `zipcode`, `coordinates`, `hostname`, `os`, `browser`, `user_agent`, `device_id`, `device_type`, `token`, `token_used`, `created_at`) VALUES
('03d3fec2-b117-4b1e-a140-3caab37ec80d', '202b02fa-053d-48d5-a307-b52adb5525f4', 'moisescelis21@gmail.com', 'User', 'Moisess', '2025-11-21 17:25:00', NULL, NULL, 0, 'Sin permisos asignados', 'failed', '::1', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', 'IT-CB01.forum.local', 'Windows 10', 'Google Chrome', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', NULL, 0, 'f6d836b899b4952efb3d5062bcd978b7bd761418dca04b921f0049ca3f7e2d9c', 0, '2025-11-21 17:25:00'),
('0fe4ce93-55a0-47d7-9cfb-7b805bccc384', '202b02fa-053d-48d5-a307-b52adb5525f4', 'moisescelis21@gmail.com', 'Administrator', 'Moisess', '2025-11-10 14:19:28', NULL, NULL, 0, 'Contraseña incorrecta', 'failed', '200.8.108.95', 'Ciudad Bolívar', 'Bolívar', 'Venezuela', 'Unknown', '8.1187,-63.5517', '200.8.108.95', 'Linux', 'Unknown Browser', 'Dalvik/2.1.0 (Linux; U; Android 15; 2412DPC0AG Build/AP3A.240905.015.A2)', 'e-lzH5uiT76dVxVrdiWZXH:APA91bGpXNX4l5SYD6vVqKUnuBySbTEpBo8YQExiB7mu9bO1lANBO9hjF6AZyFdg9zj3x1yEUSHab', 0, 'e5ab0c120d24c4f1ce28a1e2f061cb4da3880e01a6929aa26ed3e9e2f36dc05a', 0, '2025-11-10 14:19:28'),
('13353fac-d78d-4c70-9745-a89acd7677d0', '202b02fa-053d-48d5-a307-b52adb5525f4', 'moisescelis21@gmail.com', 'Administrator', 'Moisess', '2025-11-14 11:17:37', NULL, NULL, 1, NULL, 'active', '190.205.32.182', 'Caracas', 'Distrito Federal', 'Venezuela', 'Unknown', '10.4873,-66.8738', '190.205.32.182.bol-00.rai.cantv.net', 'Windows 10', 'Google Chrome', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', NULL, 0, 'e3cd580cb1fd3142576cff0931db14490d216f3d085adda599e6d61abd4b876f', 0, '2025-11-14 11:17:37'),
('150646fa-05c0-4433-97d3-064aec8ec7ca', '202b02fa-053d-48d5-a307-b52adb5525f4', 'moisescelis21@gmail.com', 'Administrator', 'Moisess', '2025-11-10 14:19:36', NULL, NULL, 1, NULL, 'active', '200.8.108.95', 'Ciudad Bolívar', 'Bolívar', 'Venezuela', 'Unknown', '8.1187,-63.5517', '200.8.108.95', 'Linux', 'Unknown Browser', 'Dalvik/2.1.0 (Linux; U; Android 15; 2412DPC0AG Build/AP3A.240905.015.A2)', 'e-lzH5uiT76dVxVrdiWZXH:APA91bGpXNX4l5SYD6vVqKUnuBySbTEpBo8YQExiB7mu9bO1lANBO9hjF6AZyFdg9zj3x1yEUSHab', 0, '572805d9580a679b75fe374d917303a8fbb197648f3df197065bbe1ec6b46e33', 1, '2025-11-10 14:19:36'),
('1de587a8-0c86-43e9-812e-7826e7cf25c7', 'd7518474-2d2f-4634-823f-71936565c110', 'zapatin@gmail.com', 'Administrator', 'Jesus Zapatin', '2025-11-10 13:16:43', NULL, NULL, 1, NULL, 'active', '190.75.94.7', 'Unknown', 'Unknown', 'Venezuela', 'Unknown', '8,-66', '190.75-94-7.pod-00-p68.cantv.net', 'Linux', 'Unknown Browser', 'Dalvik/2.1.0 (Linux; U; Android 14; TECNO KL5 Build/UP1A.231005.007)', 'cOZy-ShDTyy3z4ZsSrvKQS:APA91bEPuArUpk09cUda0aXiZhIJT4yRLFw1HzldsJr1VY3RZWISoLKgOcUbyBAVidKv5WwN_jGmM', 0, 'a3e8c50da7fa83d5522fad6d3bc0bd9da45fbdaec9e5bcff422b3e6f1194231b', 0, '2025-11-10 13:16:43'),
('339b21ba-a689-4a15-ac4d-5276bd0e3344', '202b02fa-053d-48d5-a307-b52adb5525f4', 'moisescelis21@gmail.com', 'User', 'Moisess', '2025-11-21 17:31:50', NULL, NULL, 1, NULL, 'active', '::1', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', 'IT-CB01.forum.local', 'Windows 10', 'Google Chrome', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', NULL, 0, '6c5e6cb60585a4bd47d53487060af8c7de427b41277bd1cc1e246c57efa6cdb7', 0, '2025-11-21 17:31:50'),
('34a03c7d-ebef-4d27-804a-1a1e2776c71d', '202b02fa-053d-48d5-a307-b52adb5525f4', 'moisescelis21@gmail.com', 'User', 'Moisess', '2025-11-21 17:25:16', NULL, NULL, 1, NULL, 'active', '::1', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', 'IT-CB01.forum.local', 'Windows 10', 'Google Chrome', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', NULL, 0, 'a41ad6fdfa72cd0979b2d4fd534b655df8d2b8c6530c1c36554c5c85b28ff239', 0, '2025-11-21 17:25:16'),
('39363eb1-fa9b-400b-835c-c05c7f06941d', 'd7518474-2d2f-4634-823f-71936565c110', 'zapatin@gmail.com', 'Administrator', 'Jesus Zapatin', '2025-11-14 11:29:36', NULL, NULL, 1, NULL, 'active', '::1', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', 'DESKTOP-BRTU0R4', 'Windows 10', 'Google Chrome', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', NULL, 0, 'c6618cfb2d56ee0446ad37b09065c2b65dbe15b6ca26d4f5d39acf1f9ba9dcfe', 0, '2025-11-14 11:29:36'),
('4ed635ac-c505-4ff5-8131-5513d4a8b317', '202b02fa-053d-48d5-a307-b52adb5525f4', 'moisescelis21@gmail.com', 'Administrator', 'Moisess', '2025-11-10 14:21:07', NULL, NULL, 1, NULL, 'active', '200.8.108.95', 'Ciudad Bolívar', 'Bolívar', 'Venezuela', 'Unknown', '8.1187,-63.5517', '200.8.108.95', 'Linux', 'Unknown Browser', 'Dalvik/2.1.0 (Linux; U; Android 15; 2412DPC0AG Build/AP3A.240905.015.A2)', 'e-lzH5uiT76dVxVrdiWZXH:APA91bGpXNX4l5SYD6vVqKUnuBySbTEpBo8YQExiB7mu9bO1lANBO9hjF6AZyFdg9zj3x1yEUSHab', 0, 'dbd5578c12f52d50e7d3a1a1c625b7224af13518200f0d651f37ea0a1c62a5bb', 1, '2025-11-10 14:21:07'),
('5982e6cd-4e37-40a0-a58f-a352be9f8f2d', 'd7518474-2d2f-4634-823f-71936565c110', 'zapatin@gmail.com', 'Administrator', 'Jesus Zapatin', '2025-11-10 13:29:38', NULL, NULL, 1, NULL, 'active', '190.75.94.7', 'Unknown', 'Unknown', 'Venezuela', 'Unknown', '8,-66', '190.75-94-7.pod-00-p68.cantv.net', 'Linux', 'Unknown Browser', 'Dalvik/2.1.0 (Linux; U; Android 14; TECNO KL5 Build/UP1A.231005.007)', 'cOZy-ShDTyy3z4ZsSrvKQS:APA91bEPuArUpk09cUda0aXiZhIJT4yRLFw1HzldsJr1VY3RZWISoLKgOcUbyBAVidKv5WwN_jGmM', 0, '0d25a562acd66543381c96fd13a711a7c6ccd845e9a43492a7ea137e3ff1faaa', 1, '2025-11-10 13:29:38'),
('63c8f40f-e6e0-4af3-abb7-0e46b5c51de0', '202b02fa-053d-48d5-a307-b52adb5525f4', 'moisescelis21@gmail.com', 'User', 'Moisess', '2025-11-21 17:31:47', NULL, NULL, 0, 'Contraseña incorrecta', 'failed', '::1', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', 'IT-CB01.forum.local', 'Windows 10', 'Google Chrome', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', NULL, 0, 'b5538402e7700c6d6c1830bf918aac2f824e2d222f473691d41abfff084d2720', 0, '2025-11-21 17:31:47'),
('710bf85b-5ae3-4082-953b-fc76ecba8559', '202b02fa-053d-48d5-a307-b52adb5525f4', 'moisescelis21@gmail.com', 'Administrator', 'Moisess', '2025-11-10 14:19:27', NULL, NULL, 0, 'Contraseña incorrecta', 'failed', '200.8.108.95', 'Ciudad Bolívar', 'Bolívar', 'Venezuela', 'Unknown', '8.1187,-63.5517', '200.8.108.95', 'Linux', 'Unknown Browser', 'Dalvik/2.1.0 (Linux; U; Android 15; 2412DPC0AG Build/AP3A.240905.015.A2)', 'e-lzH5uiT76dVxVrdiWZXH:APA91bGpXNX4l5SYD6vVqKUnuBySbTEpBo8YQExiB7mu9bO1lANBO9hjF6AZyFdg9zj3x1yEUSHab', 0, '74793420a8563cf89575114c913b4b5a8017d429115e9e81f7a291ad0582149d', 0, '2025-11-10 14:19:27'),
('918b23f3-8528-4fb9-9967-cb2182e07ee8', '202b02fa-053d-48d5-a307-b52adb5525f4', 'moisescelis21@gmail.com', 'Administrator', 'Moisess', '2025-11-10 14:20:09', NULL, NULL, 1, NULL, 'active', '200.8.108.95', 'Ciudad Bolívar', 'Bolívar', 'Venezuela', 'Unknown', '8.1187,-63.5517', '200.8.108.95', 'Linux', 'Unknown Browser', 'Dalvik/2.1.0 (Linux; U; Android 15; 2412DPC0AG Build/AP3A.240905.015.A2)', 'e-lzH5uiT76dVxVrdiWZXH:APA91bGpXNX4l5SYD6vVqKUnuBySbTEpBo8YQExiB7mu9bO1lANBO9hjF6AZyFdg9zj3x1yEUSHab', 0, '0384aa22d14389080d66560c6095d218b5f0348cb7eb904d10f102a1a166178d', 1, '2025-11-10 14:20:09'),
('95449c79-cd77-4784-95cc-e6b2a7ccd603', '202b02fa-053d-48d5-a307-b52adb5525f4', 'moisescelis21@gmail.com', 'Administrator', 'Moisess', '2025-11-10 14:56:40', NULL, NULL, 1, NULL, 'active', '200.8.108.95', 'Ciudad Bolívar', 'Bolívar', 'Venezuela', 'Unknown', '8.1187,-63.5517', '200.8.108.95', 'Linux', 'Unknown Browser', 'Dalvik/2.1.0 (Linux; U; Android 15; 2412DPC0AG Build/AP3A.240905.015.A2)', 'e-lzH5uiT76dVxVrdiWZXH:APA91bGpXNX4l5SYD6vVqKUnuBySbTEpBo8YQExiB7mu9bO1lANBO9hjF6AZyFdg9zj3x1yEUSHab', 0, 'e57dedc3c0767148733f661caaeca1fe548645a800ee41e37a9084cee9c74527', 1, '2025-11-10 14:56:40'),
('9a7f5964-2a02-48bb-b1a7-c0d6f49c6216', 'd7518474-2d2f-4634-823f-71936565c110', 'zapatin@gmail.com', 'Administrator', 'Jesus Zapatin', '2025-11-10 13:54:09', NULL, NULL, 1, NULL, 'active', '185.132.178.95', 'Naaldwijk', 'South Holland', 'The Netherlands', '2671', '51.9968,4.2057', '185-132-178-95.hosted-by-worldstream.net', 'Linux', 'Unknown Browser', 'Dalvik/2.1.0 (Linux; U; Android 16; SM-A566E Build/BP2A.250605.031.A3)', 'eUb8e-QET3i1y_aYOo0JXl:APA91bGAKEUCaiGJ0YohEgE8CUs3lscu_V9Vnt6bdquop6bgtJ2ihOITRP_JI7qgRVYZRdMbkGMWe', 0, 'bb078b96fbd802da3370d270953931e79d2f3246007992caeb8588be50aaca94', 1, '2025-11-10 13:54:09'),
('9d02d5a3-a899-4724-8382-4515def53c6f', '202b02fa-053d-48d5-a307-b52adb5525f4', 'moisescelis21@gmail.com', 'Administrator', 'Moisess', '2025-11-10 14:38:31', NULL, NULL, 1, NULL, 'active', '66.232.126.15', 'Tampa', 'Florida', 'United States', '33614', '28.0109,-82.4948', '66-232-126-15.static.hvvc.us', 'Windows 10', 'Google Chrome', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', NULL, 0, '08c1bcd469c5ef6e4083e7bcd0fe1d2b1a67827a1fb1ea9e3260cae1e09e53f2', 0, '2025-11-10 14:38:31'),
('ad685803-a0f3-4ca4-8ff9-d6ea22bcd9ed', '202b02fa-053d-48d5-a307-b52adb5525f4', 'moisescelis21@gmail.com', 'Administrator', 'Moisess', '2025-11-14 11:25:25', NULL, NULL, 1, NULL, 'active', '::1', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', 'DESKTOP-BRTU0R4', 'Windows 10', 'Google Chrome', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', NULL, 0, '6e86e3a4c828953e65c9c5ac07a91d3b7c10556698bea448e2141800b2d4f0f0', 0, '2025-11-14 11:25:25'),
('b7ec6025-ab26-49b5-bebe-2bc8382c0455', '202b02fa-053d-48d5-a307-b52adb5525f4', 'moisescelis21@gmail.com', 'User', 'Moisess', '2025-11-21 17:23:57', NULL, NULL, 0, 'Contraseña incorrecta', 'failed', '::1', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', 'IT-CB01.forum.local', 'Windows 10', 'Google Chrome', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', NULL, 0, 'dbcfd37f793550249bb59a1ba50c27c8de5f94c31a372adfc01c1e8969747d5e', 0, '2025-11-21 17:23:57'),
('b8f76e75-aeba-4cf0-b7cc-053b8d62c6ae', 'd7518474-2d2f-4634-823f-71936565c110', 'zapatin@gmail.com', 'Administrator', 'Jesus Zapatin', '2025-11-10 13:12:37', NULL, NULL, 1, NULL, 'active', '190.75.94.7', 'Unknown', 'Unknown', 'Venezuela', 'Unknown', '8,-66', '190.75-94-7.pod-00-p68.cantv.net', 'Linux', 'Unknown Browser', 'Dalvik/2.1.0 (Linux; U; Android 14; TECNO KL5 Build/UP1A.231005.007)', 'cOZy-ShDTyy3z4ZsSrvKQS:APA91bEPuArUpk09cUda0aXiZhIJT4yRLFw1HzldsJr1VY3RZWISoLKgOcUbyBAVidKv5WwN_jGmM', 0, '905e5eac016dc8c072caca96d25da2de6f1e677402a7a4a91d183acf0722fd9d', 0, '2025-11-10 13:12:37'),
('ca91c309-0ca3-46c2-b931-6ff89b094344', 'd7518474-2d2f-4634-823f-71936565c110', 'zapatin@gmail.com', 'Administrator', 'Jesus Zapatin', '2025-11-10 12:51:04', NULL, NULL, 1, NULL, 'active', '190.75.94.7', 'Unknown', 'Unknown', 'Venezuela', 'Unknown', '8,-66', '190.75-94-7.pod-00-p68.cantv.net', 'Linux', 'Unknown Browser', 'Dalvik/2.1.0 (Linux; U; Android 14; TECNO KL5 Build/UP1A.231005.007)', 'cOZy-ShDTyy3z4ZsSrvKQS:APA91bEPuArUpk09cUda0aXiZhIJT4yRLFw1HzldsJr1VY3RZWISoLKgOcUbyBAVidKv5WwN_jGmM', 0, '9e53f45d704af137a8ce4826185d68ea14a9a718b02b49025bfbf351c316cf42', 0, '2025-11-10 12:51:04'),
('d24bc70d-f8d0-48db-9f32-c1a6be25d00d', '202b02fa-053d-48d5-a307-b52adb5525f4', 'moisescelis21@gmail.com', 'User', 'Moisess', '2025-11-21 17:23:54', NULL, NULL, 0, 'Contraseña incorrecta', 'failed', '::1', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', 'IT-CB01.forum.local', 'Windows 10', 'Google Chrome', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', NULL, 0, '255e4e08b7f3bab9916c55a7e88a669c65a729a2a63a8e50fad26a7bdc53c13d', 0, '2025-11-21 17:23:54'),
('e9dcd279-f216-4513-906c-88d29d83219e', 'd7518474-2d2f-4634-823f-71936565c110', 'zapatin@gmail.com', 'Administrator', 'Jesus Zapatin', '2025-11-10 13:36:09', NULL, NULL, 1, NULL, 'active', '190.75.94.7', 'Unknown', 'Unknown', 'Venezuela', 'Unknown', '8,-66', '190.75-94-7.pod-00-p68.cantv.net', 'Linux', 'Unknown Browser', 'Dalvik/2.1.0 (Linux; U; Android 14; TECNO KL5 Build/UP1A.231005.007)', 'cOZy-ShDTyy3z4ZsSrvKQS:APA91bEPuArUpk09cUda0aXiZhIJT4yRLFw1HzldsJr1VY3RZWISoLKgOcUbyBAVidKv5WwN_jGmM', 0, 'a8890605bcc5da17c706b8461bd59cc87549013a6951eb765ca3a8778acf2d74', 1, '2025-11-10 13:36:09'),
('f0303622-f3ce-4d9e-9fa9-ea23197cc0c2', '202b02fa-053d-48d5-a307-b52adb5525f4', 'moisescelis21@gmail.com', 'User', 'Moisess', '2025-11-21 17:33:06', NULL, NULL, 1, NULL, 'active', '::1', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', 'IT-CB01.forum.local', 'Windows 10', 'Google Chrome', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', NULL, 0, 'ef33f9e428259ae060258a364b98e5813c8486e9ca8ad54b47d6ff6e4e2b8d8f', 0, '2025-11-21 17:33:06'),
('f69ea47c-f625-4fc2-b4ca-ce9ffaeb9200', 'd7518474-2d2f-4634-823f-71936565c110', 'zapatin@gmail.com', 'Administrator', 'Jesus Zapatin', '2025-11-10 13:38:21', NULL, NULL, 1, NULL, 'active', '190.75.94.7', 'Unknown', 'Unknown', 'Venezuela', 'Unknown', '8,-66', '190.75-94-7.pod-00-p68.cantv.net', 'Linux', 'Unknown Browser', 'Dalvik/2.1.0 (Linux; U; Android 14; TECNO KL5 Build/UP1A.231005.007)', 'cOZy-ShDTyy3z4ZsSrvKQS:APA91bEPuArUpk09cUda0aXiZhIJT4yRLFw1HzldsJr1VY3RZWISoLKgOcUbyBAVidKv5WwN_jGmM', 0, 'e3875be9a4d6017baeaea05e71a5a783eb8bd21313a9dab93172ac6927540102', 1, '2025-11-10 13:38:21'),
('f8500ea4-0bea-4c76-a234-388bebf70437', '202b02fa-053d-48d5-a307-b52adb5525f4', 'moisescelis21@gmail.com', 'User', 'Moisess', '2025-11-21 17:24:10', NULL, NULL, 0, 'Sin permisos asignados', 'failed', '::1', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0.0,0.0', 'IT-CB01.forum.local', 'Windows 10', 'Google Chrome', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', NULL, 0, 'b35c2091f4d7d49d04c4dec2439515ce72ec8d51f6931f7af986afc0eec598a2', 0, '2025-11-21 17:24:10');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `system_users`
--

CREATE TABLE `system_users` (
  `user_id` char(36) NOT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `contrasena` varchar(255) DEFAULT NULL,
  `nivel` int(11) DEFAULT NULL,
  `estado` int(11) NOT NULL DEFAULT 1,
  `dispositivo_token` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` char(36) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `system_users`
--

INSERT INTO `system_users` (`user_id`, `nombre`, `email`, `contrasena`, `nivel`, `estado`, `dispositivo_token`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('07d9bff2-7493-4695-92e0-1ca74a48db06', 'Luis Aguirrin', 'aguirrin@gmail.com', '$2y$10$GiHdtU89HFwKXHVYwWFmGeZzLIWjFjpwIYm0OyHGazFJyQmh145ky', 1, 1, NULL, '2025-10-05 16:08:11', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('1', 'Fatima Gomez', 'fatimagomezpd@gmail.com', '$2y$10$EyP1MOY39kuw4uREdk7ao.UUzQ10YNIZ95IZLM70MUPo5J6YzEBVG', 1, 1, NULL, NULL, NULL, NULL, NULL, '2025-10-05 16:14:00', 'd7518474-2d2f-4634-823f-71936565c110'),
('202b02fa-053d-48d5-a307-b52adb5525f4', 'Moisess', 'moisescelis21@gmail.com', '$2y$10$Zc9Gk5CZGhQEqjBungBVdukN/kaUGH4Ur4zyPq4UZ7KlQr02lnqIO', 1, 1, 'e-lzH5uiT76dVxVrdiWZXH:APA91bGpXNX4l5SYD6vVqKUnuBySbTEpBo8YQExiB7mu9bO1lANBO9hjF6AZyFdg9zj3x1yEUSHabFBKNqBbP_HZSCUX3QbWR7oC5ptzRuHHBXxovpEKuy8', '2025-10-05 19:52:49', 'd7518474-2d2f-4634-823f-71936565c110', '2025-11-21 17:24:07', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL),
('35', 'Ricardo', 'jose.2710.ricardo@gmail.com', '$2y$10$xTVUq4JFTu6S7z7pCZtWTuC8ukfj0r3jsFk7Nw62TtU1WtnZ87MDm', 1, 1, NULL, NULL, NULL, '2025-10-04 10:49:45', '35', NULL, NULL),
('40', 'Hilson Martinez', 'martinezhilson8@gmail.com', '$2y$10$3mEuUd1/uIn0nNx3.qBoYeGeDc7WAXsEUvldqHX1WNaWusgVwnu9e', 2, 1, NULL, NULL, NULL, NULL, NULL, '2025-10-05 16:14:03', 'd7518474-2d2f-4634-823f-71936565c110'),
('42', 'ASDRUBAL MARTINEZs', 'asdrubalmartinez486@gmail.com', '$2y$10$yUnVJhDWX6xkB4BEch2HPeAbEGNA311qcjs1DXVIsTmaah6jzHwzW', 2, 1, NULL, NULL, NULL, '2025-10-04 09:49:28', '42', '2025-10-05 16:13:58', 'd7518474-2d2f-4634-823f-71936565c110'),
('43', 'user ejecucion', 'magomagel1983@gmail.com', '$2y$10$EyP1MOY39kuw4uREdk7ao.UUzQ10YNIZ95IZLM70MUPo5J6YzEBVG', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('45', 'user proyectos', 'proyecto@correo.com', '$2y$10$EyP1MOY39kuw4uREdk7ao.UUzQ10YNIZ95IZLM70MUPo5J6YzEBVG', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('d7518474-2d2f-4634-823f-71936565c110', 'Jesus Zapatin', 'zapatin@gmail.com', '$2y$10$H.Y1gpOJFRMCObm0rNPZ4uHfis56lTpKacsf1hrvWvwefwDJHNujq', 0, 1, 'cOZy-ShDTyy3z4ZsSrvKQS:APA91bEPuArUpk09cUda0aXiZhIJT4yRLFw1HzldsJr1VY3RZWISoLKgOcUbyBAVidKv5WwN_jGmMaulQy-wdoNYz7zMjDWZALS6kdXXwaq3YM7XU7kcxB8', '2025-10-04 10:50:51', 'd7518474-2d2f-4634-823f-71936565c110', '2025-11-10 13:54:09', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL);

--
-- Disparadores `system_users`
--
DELIMITER $$
CREATE TRIGGER `trg_system_users_delete` BEFORE DELETE ON `system_users` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'system_users', OLD.user_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'user_id', OLD.user_id,
      'nombre', OLD.nombre,
      'email', OLD.email,
      'contrasena', OLD.contrasena,
      'nivel', OLD.nivel,
      'estado', OLD.estado,
      'dispositivo_token', OLD.dispositivo_token,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_system_users_delete_logical` AFTER UPDATE ON `system_users` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'system_users', OLD.user_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'user_id', OLD.user_id,
        'nombre', OLD.nombre,
        'email', OLD.email,
        'contrasena', OLD.contrasena,
        'nivel', OLD.nivel,
        'estado', OLD.estado,
        'dispositivo_token', OLD.dispositivo_token,
        'created_at', OLD.created_at,
        'created_by', OLD.created_by,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_system_users_insert` AFTER INSERT ON `system_users` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'system_users', NEW.user_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'user_id', NEW.user_id,
      'nombre', NEW.nombre,
      'email', NEW.email,
      'contrasena', NEW.contrasena,
      'nivel', NEW.nivel,
      'estado', NEW.estado,
      'dispositivo_token', NEW.dispositivo_token,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_system_users_update` AFTER UPDATE ON `system_users` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.nombre <> NEW.nombre THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"nombre":{"old":"', escape_json(OLD.nombre), '","new":"', escape_json(NEW.nombre), '"}');
  END IF;
  IF OLD.email <> NEW.email THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"email":{"old":"', escape_json(OLD.email), '","new":"', escape_json(NEW.email), '"}');
  END IF;
  IF OLD.contrasena <> NEW.contrasena THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"contrasena":{"old":"', escape_json(OLD.contrasena), '","new":"', escape_json(NEW.contrasena), '"}');
  END IF;
  IF OLD.nivel <> NEW.nivel THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"nivel":{"old":"', escape_json(OLD.nivel), '","new":"', escape_json(NEW.nivel), '"}');
  END IF;
  IF OLD.estado <> NEW.estado THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"estado":{"old":"', escape_json(OLD.estado), '","new":"', escape_json(NEW.estado), '"}');
  END IF;
  IF OLD.dispositivo_token <> NEW.dispositivo_token THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"dispositivo_token":{"old":"', escape_json(OLD.dispositivo_token), '","new":"', escape_json(NEW.dispositivo_token), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'system_users', OLD.user_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tabuladores_peso`
--

CREATE TABLE `tabuladores_peso` (
  `tab_peso_id` char(36) NOT NULL,
  `raza_id` char(36) NOT NULL,
  `edad_min_dias` int(11) NOT NULL,
  `edad_max_dias` int(11) NOT NULL,
  `peso_ideal` decimal(5,2) NOT NULL,
  `margen_min` decimal(5,2) NOT NULL,
  `margen_max` decimal(5,2) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tabuladores_peso`
--

INSERT INTO `tabuladores_peso` (`tab_peso_id`, `raza_id`, `edad_min_dias`, `edad_max_dias`, `peso_ideal`, `margen_min`, `margen_max`, `created_at`, `created_by`) VALUES
('a1a1a1a1-a1a1-4a1a-a1a1-a1a1a1a1a1a1', '11111111-1111-1111-1111-111111111111', 18, 24, 6.80, 1.00, 1.00, '2025-10-22 10:50:18', NULL),
('a1a1a1a1-a1a1-4a1a-a1a1-a1a1a1a1a1a2', '11111111-1111-1111-1111-111111111111', 25, 31, 8.50, 1.00, 1.00, '2025-10-22 10:50:18', NULL),
('a1a1a1a1-a1a1-4a1a-a1a1-a1a1a1a1a1a3', '11111111-1111-1111-1111-111111111111', 32, 38, 10.80, 1.50, 1.50, '2025-10-22 10:50:18', NULL),
('a1a1a1a1-a1a1-4a1a-a1a1-a1a1a1a1a1a4', '11111111-1111-1111-1111-111111111111', 39, 59, 17.20, 1.80, 1.80, '2025-10-22 10:50:18', NULL),
('a1a1a1a1-a1a1-4a1a-a1a1-a1a1a1a1a1a5', '11111111-1111-1111-1111-111111111111', 60, 89, 28.40, 2.20, 2.20, '2025-10-22 10:50:18', NULL),
('a1a1a1a1-a1a1-4a1a-a1a1-a1a1a1a1a1a6', '11111111-1111-1111-1111-111111111111', 90, 119, 50.00, 3.00, 3.00, '2025-10-22 10:50:18', NULL),
('b2b2b2b2-b2b2-4b2b-b2b2-b2b2b2b2b2b1', '22222222-2222-2222-2222-222222222222', 18, 24, 6.70, 1.00, 1.00, '2025-10-22 10:50:18', NULL),
('b2b2b2b2-b2b2-4b2b-b2b2-b2b2b2b2b2b2', '22222222-2222-2222-2222-222222222222', 25, 31, 8.40, 1.00, 1.00, '2025-10-22 10:50:18', NULL),
('b2b2b2b2-b2b2-4b2b-b2b2-b2b2b2b2b2b3', '22222222-2222-2222-2222-222222222222', 32, 38, 10.60, 1.50, 1.50, '2025-10-22 10:50:18', NULL),
('b2b2b2b2-b2b2-4b2b-b2b2-b2b2b2b2b2b4', '22222222-2222-2222-2222-222222222222', 39, 59, 17.00, 1.80, 1.80, '2025-10-22 10:50:18', NULL),
('b2b2b2b2-b2b2-4b2b-b2b2-b2b2b2b2b2b5', '22222222-2222-2222-2222-222222222222', 60, 89, 28.00, 2.20, 2.20, '2025-10-22 10:50:18', NULL),
('b2b2b2b2-b2b2-4b2b-b2b2-b2b2b2b2b2b6', '22222222-2222-2222-2222-222222222222', 90, 119, 49.00, 3.00, 3.00, '2025-10-22 10:50:18', NULL),
('c3c3c3c3-c3c3-4c3c-c3c3-c3c3c3c3c3c1', '33333333-3333-3333-3333-333333333333', 18, 24, 6.90, 1.00, 1.00, '2025-10-22 10:50:18', NULL),
('c3c3c3c3-c3c3-4c3c-c3c3-c3c3c3c3c3c2', '33333333-3333-3333-3333-333333333333', 25, 31, 8.70, 1.00, 1.00, '2025-10-22 10:50:18', NULL),
('c3c3c3c3-c3c3-4c3c-c3c3-c3c3c3c3c3c3', '33333333-3333-3333-3333-333333333333', 32, 38, 11.00, 1.50, 1.50, '2025-10-22 10:50:18', NULL),
('c3c3c3c3-c3c3-4c3c-c3c3-c3c3c3c3c3c4', '33333333-3333-3333-3333-333333333333', 39, 59, 17.80, 1.80, 1.80, '2025-10-22 10:50:18', NULL),
('c3c3c3c3-c3c3-4c3c-c3c3-c3c3c3c3c3c5', '33333333-3333-3333-3333-333333333333', 60, 89, 29.20, 2.20, 2.20, '2025-10-22 10:50:18', NULL),
('c3c3c3c3-c3c3-4c3c-c3c3-c3c3c3c3c3c6', '33333333-3333-3333-3333-333333333333', 90, 119, 51.50, 3.00, 3.00, '2025-10-22 10:50:18', NULL),
('d4d4d4d4-d4d4-4d4d-d4d4-d4d4d4d4d4d1', '44444444-4444-4444-4444-444444444444', 18, 24, 6.60, 1.00, 1.00, '2025-10-22 10:50:18', NULL),
('d4d4d4d4-d4d4-4d4d-d4d4-d4d4d4d4d4d2', '44444444-4444-4444-4444-444444444444', 25, 31, 8.30, 1.00, 1.00, '2025-10-22 10:50:18', NULL),
('d4d4d4d4-d4d4-4d4d-d4d4-d4d4d4d4d4d3', '44444444-4444-4444-4444-444444444444', 32, 38, 10.40, 1.50, 1.50, '2025-10-22 10:50:18', NULL),
('d4d4d4d4-d4d4-4d4d-d4d4-d4d4d4d4d4d4', '44444444-4444-4444-4444-444444444444', 39, 59, 16.60, 1.80, 1.80, '2025-10-22 10:50:18', NULL),
('d4d4d4d4-d4d4-4d4d-d4d4-d4d4d4d4d4d5', '44444444-4444-4444-4444-444444444444', 60, 89, 27.60, 2.20, 2.20, '2025-10-22 10:50:18', NULL),
('d4d4d4d4-d4d4-4d4d-d4d4-d4d4d4d4d4d6', '44444444-4444-4444-4444-444444444444', 90, 119, 48.00, 3.00, 3.00, '2025-10-22 10:50:18', NULL),
('e5e5e5e5-e5e5-4e5e-e5e5-e5e5e5e5e5e1', '55555555-5555-5555-5555-555555555555', 18, 24, 6.70, 1.00, 1.00, '2025-10-22 10:50:18', NULL),
('e5e5e5e5-e5e5-4e5e-e5e5-e5e5e5e5e5e2', '55555555-5555-5555-5555-555555555555', 25, 31, 8.50, 1.00, 1.00, '2025-10-22 10:50:18', NULL),
('e5e5e5e5-e5e5-4e5e-e5e5-e5e5e5e5e5e3', '55555555-5555-5555-5555-555555555555', 32, 38, 10.70, 1.50, 1.50, '2025-10-22 10:50:18', NULL),
('e5e5e5e5-e5e5-4e5e-e5e5-e5e5e5e5e5e4', '55555555-5555-5555-5555-555555555555', 39, 59, 17.40, 1.80, 1.80, '2025-10-22 10:50:18', NULL),
('e5e5e5e5-e5e5-4e5e-e5e5-e5e5e5e5e5e5', '55555555-5555-5555-5555-555555555555', 60, 89, 28.60, 2.20, 2.20, '2025-10-22 10:50:18', NULL),
('e5e5e5e5-e5e5-4e5e-e5e5-e5e5e5e5e5e6', '55555555-5555-5555-5555-555555555555', 90, 119, 50.50, 3.00, 3.00, '2025-10-22 10:50:18', NULL),
('m3m3m3m3-m3m3-4m3m-m3m3-m3m3m3m3m3m1', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 18, 24, 6.10, 1.00, 1.00, '2025-10-22 10:50:18', NULL),
('m3m3m3m3-m3m3-4m3m-m3m3-m3m3m3m3m3m2', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 25, 31, 7.80, 1.00, 1.00, '2025-10-22 10:50:18', NULL),
('m3m3m3m3-m3m3-4m3m-m3m3-m3m3m3m3m3m3', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 32, 38, 9.90, 1.50, 1.50, '2025-10-22 10:50:18', NULL),
('m3m3m3m3-m3m3-4m3m-m3m3-m3m3m3m3m3m4', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 39, 59, 15.50, 1.80, 1.80, '2025-10-22 10:50:18', NULL),
('m3m3m3m3-m3m3-4m3m-m3m3-m3m3m3m3m3m5', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 60, 89, 25.80, 2.20, 2.20, '2025-10-22 10:50:18', NULL),
('m3m3m3m3-m3m3-4m3m-m3m3-m3m3m3m3m3m6', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 90, 119, 44.00, 3.00, 3.00, '2025-10-22 10:50:18', NULL);

--
-- Disparadores `tabuladores_peso`
--
DELIMITER $$
CREATE TRIGGER `trg_tabuladores_peso_delete` BEFORE DELETE ON `tabuladores_peso` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'tabuladores_peso', OLD.tab_peso_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'tab_peso_id', OLD.tab_peso_id,
      'raza_id', OLD.raza_id,
      'edad_min_dias', OLD.edad_min_dias,
      'edad_max_dias', OLD.edad_max_dias,
      'peso_ideal', OLD.peso_ideal,
      'margen_min', OLD.margen_min,
      'margen_max', OLD.margen_max,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_tabuladores_peso_insert` AFTER INSERT ON `tabuladores_peso` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'tabuladores_peso', NEW.tab_peso_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'tab_peso_id', NEW.tab_peso_id,
      'raza_id', NEW.raza_id,
      'edad_min_dias', NEW.edad_min_dias,
      'edad_max_dias', NEW.edad_max_dias,
      'peso_ideal', NEW.peso_ideal,
      'margen_min', NEW.margen_min,
      'margen_max', NEW.margen_max,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_tabuladores_peso_update` AFTER UPDATE ON `tabuladores_peso` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.raza_id <> NEW.raza_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"raza_id":{"old":"', escape_json(OLD.raza_id), '","new":"', escape_json(NEW.raza_id), '"}');
  END IF;
  IF OLD.edad_min_dias <> NEW.edad_min_dias THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"edad_min_dias":{"old":"', escape_json(OLD.edad_min_dias), '","new":"', escape_json(NEW.edad_min_dias), '"}');
  END IF;
  IF OLD.edad_max_dias <> NEW.edad_max_dias THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"edad_max_dias":{"old":"', escape_json(OLD.edad_max_dias), '","new":"', escape_json(NEW.edad_max_dias), '"}');
  END IF;
  IF OLD.peso_ideal <> NEW.peso_ideal THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"peso_ideal":{"old":"', escape_json(OLD.peso_ideal), '","new":"', escape_json(NEW.peso_ideal), '"}');
  END IF;
  IF OLD.margen_min <> NEW.margen_min THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"margen_min":{"old":"', escape_json(OLD.margen_min), '","new":"', escape_json(NEW.margen_min), '"}');
  END IF;
  IF OLD.margen_max <> NEW.margen_max THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"margen_max":{"old":"', escape_json(OLD.margen_max), '","new":"', escape_json(NEW.margen_max), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'tabuladores_peso', OLD.tab_peso_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users_permisos`
--

CREATE TABLE `users_permisos` (
  `users_permisos_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `menu_id` char(36) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` char(36) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `users_permisos`
--

INSERT INTO `users_permisos` (`users_permisos_id`, `user_id`, `menu_id`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) VALUES
('5309a0b7-a133-11f0-a92b-74d02b268d93', 'd7518474-2d2f-4634-823f-71936565c110', '35f8606a-a133-11f0-a92b-74d02b268d93', NULL, NULL, NULL, NULL, NULL, NULL),
('702e6d19-c932-409f-b20a-f25c14774164', '07d9bff2-7493-4695-92e0-1ca74a48db06', '920a038d-e341-4c61-9915-d35fb41d1a6b', '2025-10-05 16:08:48', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('aae73a28-a1b0-4e1c-a4a1-35bd10e7819a', '202b02fa-053d-48d5-a307-b52adb5525f4', 'f21ee10a-2cce-452c-96f1-0f4bf9fe2090', '2025-11-21 17:33:22', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('c7966efb-64c9-45b1-aa2e-c61af76a6cef', '202b02fa-053d-48d5-a307-b52adb5525f4', '70ce973a-97ea-419e-9111-17d36638e3c7', '2025-11-21 17:32:58', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('d349f835-8f99-49a0-909d-b9fd2385b77d', '202b02fa-053d-48d5-a307-b52adb5525f4', '1be82974-a797-4bea-aae1-0d7112727ec4', '2025-11-21 17:31:11', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL),
('ea8ce31e-a9ef-4695-8dbc-78557dbefbdf', '202b02fa-053d-48d5-a307-b52adb5525f4', '0aa79a19-946d-4993-90b1-84d352ad78a1', '2025-11-21 17:25:14', 'd7518474-2d2f-4634-823f-71936565c110', NULL, NULL, NULL, NULL);

--
-- Disparadores `users_permisos`
--
DELIMITER $$
CREATE TRIGGER `trg_users_permisos_delete` BEFORE DELETE ON `users_permisos` FOR EACH ROW BEGIN
  -- Defaults seguros
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'users_permisos', OLD.users_permisos_id, 'DELETE_PHYSICAL', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'users_permisos_id', OLD.users_permisos_id,
      'user_id', OLD.user_id,
      'menu_id', OLD.menu_id,
      'created_at', OLD.created_at,
      'created_by', OLD.created_by,
      'updated_at', OLD.updated_at,
      'updated_by', OLD.updated_by,
      'deleted_at', OLD.deleted_at,
      'deleted_by', OLD.deleted_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_users_permisos_delete_logical` AFTER UPDATE ON `users_permisos` FOR EACH ROW BEGIN
  -- Declaraciones
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'users_permisos', OLD.users_permisos_id, 'DELETE_LOGICAL', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      JSON_OBJECT('deleted_at', JSON_OBJECT('old', NULL, 'new', NEW.deleted_at)),
      JSON_OBJECT(
        'users_permisos_id', OLD.users_permisos_id,
        'user_id', OLD.user_id,
        'menu_id', OLD.menu_id,
        'created_at', OLD.created_at,
        'created_by', OLD.created_by,
        'updated_at', OLD.updated_at,
        'updated_by', OLD.updated_by,
        'deleted_at', NEW.deleted_at,
        'deleted_by', NEW.deleted_by
      ),
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_users_permisos_insert` AFTER INSERT ON `users_permisos` FOR EACH ROW BEGIN
  -- Declaraciones (igual que en delete)
  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  INSERT INTO audit_log (
    table_name, record_id, action_type, action_by,
    full_name, user_type, action_timestamp, action_timezone,
    changes, full_row,
    client_ip, client_hostname, user_agent,
    client_os, client_browser,
    domain_name, request_uri, server_hostname,
    client_country, client_region, client_city,
    client_zipcode, client_coordinates,
    geo_ip_timestamp, geo_ip_timezone
  ) VALUES (
    'users_permisos', NEW.users_permisos_id, 'INSERT', v_action_by,
    v_full_name, v_user_type, NOW(), v_action_timezone,
    NULL,
    JSON_OBJECT(
      'users_permisos_id', NEW.users_permisos_id,
      'user_id', NEW.user_id,
      'menu_id', NEW.menu_id,
      'created_at', NEW.created_at,
      'created_by', NEW.created_by
    ),
    v_client_ip, v_client_hostname, v_user_agent,
    v_client_os, v_client_browser,
    v_domain_name, v_request_uri, v_server_hostname,
    v_client_country, v_client_region, v_client_city,
    v_client_zipcode, v_client_coordinates,
    v_geo_ip_timestamp, v_geo_ip_timezone
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_users_permisos_update` AFTER UPDATE ON `users_permisos` FOR EACH ROW BEGIN
  DECLARE change_data TEXT DEFAULT '{';

  DECLARE v_action_by CHAR(36)        DEFAULT COALESCE(@user_id, 0);
  DECLARE v_full_name VARCHAR(255)    DEFAULT COALESCE(@full_name, 'phpMyAdmin');
  DECLARE v_user_type VARCHAR(50)     DEFAULT COALESCE(@user_type, 'system');
  DECLARE v_action_timezone VARCHAR(64) DEFAULT COALESCE(@action_timezone, @@session.time_zone);
  DECLARE v_client_ip VARCHAR(64)     DEFAULT COALESCE(@client_ip, '127.0.0.1');
  DECLARE v_client_hostname VARCHAR(255) DEFAULT COALESCE(@client_hostname, 'localhost');
  DECLARE v_user_agent TEXT           DEFAULT COALESCE(@user_agent, 'phpMyAdmin');
  DECLARE v_client_os VARCHAR(64)     DEFAULT COALESCE(@client_os, 'unknown');
  DECLARE v_client_browser VARCHAR(64) DEFAULT COALESCE(@client_browser, 'phpMyAdmin');
  DECLARE v_domain_name VARCHAR(255)  DEFAULT COALESCE(@domain_name, '');
  DECLARE v_request_uri VARCHAR(255)  DEFAULT COALESCE(@request_uri, '');
  DECLARE v_server_hostname VARCHAR(255) DEFAULT COALESCE(@server_hostname, @@hostname);
  DECLARE v_client_country VARCHAR(64) DEFAULT COALESCE(@client_country, '');
  DECLARE v_client_region VARCHAR(64)  DEFAULT COALESCE(@client_region, '');
  DECLARE v_client_city VARCHAR(64)   DEFAULT COALESCE(@client_city, '');
  DECLARE v_client_zipcode VARCHAR(32) DEFAULT COALESCE(@client_zipcode, '');
  DECLARE v_client_coordinates VARCHAR(64) DEFAULT COALESCE(@client_coordinates, '');
  DECLARE v_geo_ip_timestamp DATETIME DEFAULT COALESCE(@geo_ip_timestamp, NOW());
  DECLARE v_geo_ip_timezone VARCHAR(64) DEFAULT COALESCE(@geo_ip_timezone, @@session.time_zone);

  -- JSON de cambios
  IF OLD.user_id <> NEW.user_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"user_id":{"old":"', escape_json(OLD.user_id), '","new":"', escape_json(NEW.user_id), '"}');
  END IF;
  IF OLD.menu_id <> NEW.menu_id THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"menu_id":{"old":"', escape_json(OLD.menu_id), '","new":"', escape_json(NEW.menu_id), '"}');
  END IF;
  IF OLD.updated_at <> NEW.updated_at THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_at":{"old":"', escape_json(OLD.updated_at), '","new":"', escape_json(NEW.updated_at), '"}');
  END IF;
  IF OLD.updated_by <> NEW.updated_by THEN
    SET change_data = CONCAT(change_data, IF(change_data = '{', '', ','), '"updated_by":{"old":"', escape_json(OLD.updated_by), '","new":"', escape_json(NEW.updated_by), '"}');
  END IF;

  SET change_data = CONCAT(change_data, '}');

  IF change_data <> '{}' THEN
    INSERT INTO audit_log (
      table_name, record_id, action_type, action_by,
      full_name, user_type, action_timestamp, action_timezone,
      changes, full_row,
      client_ip, client_hostname, user_agent,
      client_os, client_browser,
      domain_name, request_uri, server_hostname,
      client_country, client_region, client_city,
      client_zipcode, client_coordinates,
      geo_ip_timestamp, geo_ip_timezone
    ) VALUES (
      'users_permisos', OLD.users_permisos_id, 'UPDATE', v_action_by,
      v_full_name, v_user_type, NOW(), v_action_timezone,
      change_data, NULL,
      v_client_ip, v_client_hostname, v_user_agent,
      v_client_os, v_client_browser,
      v_domain_name, v_request_uri, v_server_hostname,
      v_client_country, v_client_region, v_client_city,
      v_client_zipcode, v_client_coordinates,
      v_geo_ip_timestamp, v_geo_ip_timezone
    );
  END IF;
END
$$
DELIMITER ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `acontecimiento_reportes`
--
ALTER TABLE `acontecimiento_reportes`
  ADD PRIMARY KEY (`acontecimiento_id`);

--
-- Indices de la tabla `alertas`
--
ALTER TABLE `alertas`
  ADD PRIMARY KEY (`alerta_id`),
  ADD KEY `fk_alerta_periodo` (`periodo_id`),
  ADD KEY `fk_alerta_animal` (`animal_id`),
  ADD KEY `idx_alertas_objetivo` (`tipo_alerta`,`estado_alerta`,`fecha_objetivo`),
  ADD KEY `idx_alertas_origen` (`origen_modulo`,`referencia_id`);

--
-- Indices de la tabla `animales`
--
ALTER TABLE `animales`
  ADD PRIMARY KEY (`animal_id`),
  ADD UNIQUE KEY `uq_animales_identificador` (`identificador`),
  ADD KEY `fk_animal_madre` (`madre_id`),
  ADD KEY `fk_animal_padre` (`padre_id`),
  ADD KEY `idx_animales_especie` (`especie`),
  ADD KEY `idx_animales_sexo` (`sexo`),
  ADD KEY `idx_animales_estado` (`estado`),
  ADD KEY `idx_animales_nac` (`fecha_nacimiento`),
  ADD KEY `fk_animales_raza` (`raza_id`),
  ADD KEY `fk_animal_camada` (`camada_id`);

--
-- Indices de la tabla `animal_decesos`
--
ALTER TABLE `animal_decesos`
  ADD PRIMARY KEY (`deceso_id`);

--
-- Indices de la tabla `animal_movimientos`
--
ALTER TABLE `animal_movimientos`
  ADD PRIMARY KEY (`animal_movimiento_id`),
  ADD KEY `idx_am_animal` (`animal_id`),
  ADD KEY `idx_am_fecha` (`fecha_mov`),
  ADD KEY `idx_am_tipo` (`tipo_movimiento`),
  ADD KEY `idx_am_estado` (`estado`),
  ADD KEY `idx_am_origen_finca` (`finca_origen_id`),
  ADD KEY `idx_am_origen_aprisco` (`aprisco_origen_id`),
  ADD KEY `idx_am_origen_area` (`area_origen_id`),
  ADD KEY `idx_am_dest_finca` (`finca_destino_id`),
  ADD KEY `idx_am_dest_aprisco` (`aprisco_destino_id`),
  ADD KEY `idx_am_dest_area` (`area_destino_id`),
  ADD KEY `idx_am_recinto_origen` (`recinto_id_origen`),
  ADD KEY `idx_am_recinto_dest` (`recinto_id_destino`);

--
-- Indices de la tabla `animal_pesos`
--
ALTER TABLE `animal_pesos`
  ADD PRIMARY KEY (`animal_peso_id`),
  ADD UNIQUE KEY `uq_animal_peso_fecha` (`animal_id`,`fecha_peso`),
  ADD KEY `idx_animal_pesos_animal` (`animal_id`),
  ADD KEY `idx_animal_pesos_fecha` (`fecha_peso`);

--
-- Indices de la tabla `animal_salud`
--
ALTER TABLE `animal_salud`
  ADD PRIMARY KEY (`animal_salud_id`),
  ADD KEY `idx_salud_animal` (`animal_id`),
  ADD KEY `idx_salud_fecha` (`fecha_evento`),
  ADD KEY `idx_salud_estado` (`estado`),
  ADD KEY `idx_salud_tipo` (`tipo_evento`),
  ADD KEY `fk_salud_incidencia` (`incidencia_id`),
  ADD KEY `fk_as_acontecimiento` (`acontecimiento_id`);

--
-- Indices de la tabla `animal_ubicaciones`
--
ALTER TABLE `animal_ubicaciones`
  ADD PRIMARY KEY (`animal_ubicacion_id`),
  ADD KEY `idx_au_animal` (`animal_id`),
  ADD KEY `idx_au_finca` (`finca_id`),
  ADD KEY `idx_au_aprisc` (`aprisco_id`),
  ADD KEY `idx_au_area` (`area_id`),
  ADD KEY `idx_au_desde` (`fecha_desde`),
  ADD KEY `idx_au_hasta` (`fecha_hasta`),
  ADD KEY `idx_au_recinto` (`recinto_id`);

--
-- Indices de la tabla `apriscos`
--
ALTER TABLE `apriscos`
  ADD PRIMARY KEY (`aprisco_id`),
  ADD KEY `idx_aprisco_finca` (`finca_id`);

--
-- Indices de la tabla `areas`
--
ALTER TABLE `areas`
  ADD PRIMARY KEY (`area_id`),
  ADD UNIQUE KEY `uq_area_tipo_num` (`aprisco_id`,`tipo_area`,`numeracion`),
  ADD UNIQUE KEY `uq_area_nombre_personalizado` (`aprisco_id`,`nombre_personalizado`),
  ADD KEY `idx_area_aprisco` (`aprisco_id`);

--
-- Indices de la tabla `audit_log`
--
ALTER TABLE `audit_log`
  ADD PRIMARY KEY (`audit_id`);

--
-- Indices de la tabla `camadas`
--
ALTER TABLE `camadas`
  ADD PRIMARY KEY (`camada_id`),
  ADD KEY `fk_camada_parto` (`parto_id`),
  ADD KEY `fk_camada_madre` (`madre_id`),
  ADD KEY `idx_camada_deleted` (`deleted_at`);

--
-- Indices de la tabla `camada_bajas`
--
ALTER TABLE `camada_bajas`
  ADD PRIMARY KEY (`baja_id`),
  ADD KEY `fk_baja_camada` (`camada_id`),
  ADD KEY `idx_baja_deleted` (`deleted_at`);

--
-- Indices de la tabla `configuraciones`
--
ALTER TABLE `configuraciones`
  ADD PRIMARY KEY (`config_id`),
  ADD UNIQUE KEY `uq_config_key` (`config_key`);

--
-- Indices de la tabla `fincas`
--
ALTER TABLE `fincas`
  ADD PRIMARY KEY (`finca_id`);

--
-- Indices de la tabla `incidencias`
--
ALTER TABLE `incidencias`
  ADD PRIMARY KEY (`incidencia_id`),
  ADD KEY `idx_incid_animal` (`animal_id`),
  ADD KEY `idx_incid_tipo_fecha` (`tipo`,`fecha_evento`),
  ADD KEY `idx_incid_area` (`area_id`),
  ADD KEY `idx_incidencias_fotografia_url` (`fotografia_url`);

--
-- Indices de la tabla `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`menu_id`);

--
-- Indices de la tabla `menu_categorias`
--
ALTER TABLE `menu_categorias`
  ADD PRIMARY KEY (`categoria_id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notifications_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_module` (`module`);

--
-- Indices de la tabla `partos`
--
ALTER TABLE `partos`
  ADD PRIMARY KEY (`parto_id`),
  ADD KEY `fk_parto_periodo` (`periodo_id`),
  ADD KEY `idx_partos_fotografia_url` (`fotografia_url`);

--
-- Indices de la tabla `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`password_reset_id`),
  ADD KEY `idx_email` (`email`);

--
-- Indices de la tabla `periodos_servicio`
--
ALTER TABLE `periodos_servicio`
  ADD PRIMARY KEY (`periodo_id`),
  ADD KEY `fk_ps_hembra` (`hembra_id`),
  ADD KEY `fk_ps_verraco` (`verraco_id`);

--
-- Indices de la tabla `razas`
--
ALTER TABLE `razas`
  ADD PRIMARY KEY (`raza_id`),
  ADD UNIQUE KEY `uq_razas_codigo` (`especie`,`codigo`),
  ADD UNIQUE KEY `uq_razas_nombre` (`especie`,`nombre`),
  ADD KEY `idx_razas_estado` (`estado`);

--
-- Indices de la tabla `recintos`
--
ALTER TABLE `recintos`
  ADD PRIMARY KEY (`recinto_id`),
  ADD UNIQUE KEY `uq_area_codigo_recinto` (`area_id`,`codigo_recinto`);

--
-- Indices de la tabla `reportes_dano`
--
ALTER TABLE `reportes_dano`
  ADD PRIMARY KEY (`reporte_id`),
  ADD KEY `fk_rep_aprisco` (`aprisco_id`),
  ADD KEY `fk_rep_area` (`area_id`),
  ADD KEY `idx_rep_refs` (`finca_id`,`aprisco_id`,`area_id`),
  ADD KEY `idx_rep_estado_fecha` (`estado_reporte`,`fecha_reporte`),
  ADD KEY `idx_rep_criticidad` (`criticidad`);

--
-- Indices de la tabla `revisiones_servicio`
--
ALTER TABLE `revisiones_servicio`
  ADD PRIMARY KEY (`revision_id`),
  ADD KEY `fk_rev_periodo` (`periodo_id`),
  ADD KEY `idx_revisiones_programada` (`fecha_programada`,`resultado`),
  ADD KEY `idx_rev_periodo` (`revision_id`),
  ADD KEY `idx_rev_programada` (`fecha_programada`),
  ADD KEY `idx_rev_resultado` (`resultado`),
  ADD KEY `idx_rev_deleted_at` (`deleted_at`);

--
-- Indices de la tabla `saneamiento_areas`
--
ALTER TABLE `saneamiento_areas`
  ADD PRIMARY KEY (`saneamiento_areas_id`);

--
-- Indices de la tabla `servicios`
--
ALTER TABLE `servicios`
  ADD PRIMARY KEY (`monta_id`),
  ADD UNIQUE KEY `uq_monta_periodo_num` (`periodo_id`,`numero_monta`);

--
-- Indices de la tabla `session_config`
--
ALTER TABLE `session_config`
  ADD PRIMARY KEY (`config_id`);

--
-- Indices de la tabla `session_management`
--
ALTER TABLE `session_management`
  ADD PRIMARY KEY (`session_id`);

--
-- Indices de la tabla `system_users`
--
ALTER TABLE `system_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `usuario` (`email`);

--
-- Indices de la tabla `tabuladores_peso`
--
ALTER TABLE `tabuladores_peso`
  ADD PRIMARY KEY (`tab_peso_id`),
  ADD KEY `idx_tab_raza_edad` (`raza_id`,`edad_min_dias`,`edad_max_dias`);

--
-- Indices de la tabla `users_permisos`
--
ALTER TABLE `users_permisos`
  ADD PRIMARY KEY (`users_permisos_id`),
  ADD UNIQUE KEY `uq_user_menu` (`user_id`,`menu_id`),
  ADD KEY `fk_up_menu` (`menu_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `audit_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=152;

--
-- AUTO_INCREMENT de la tabla `menu_categorias`
--
ALTER TABLE `menu_categorias`
  MODIFY `categoria_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `password_reset_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `session_config`
--
ALTER TABLE `session_config`
  MODIFY `config_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `alertas`
--
ALTER TABLE `alertas`
  ADD CONSTRAINT `fk_alerta_animal` FOREIGN KEY (`animal_id`) REFERENCES `animales` (`animal_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_alerta_periodo` FOREIGN KEY (`periodo_id`) REFERENCES `periodos_servicio` (`periodo_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `animales`
--
ALTER TABLE `animales`
  ADD CONSTRAINT `fk_animal_camada` FOREIGN KEY (`camada_id`) REFERENCES `camadas` (`camada_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_animal_madre` FOREIGN KEY (`madre_id`) REFERENCES `animales` (`animal_id`),
  ADD CONSTRAINT `fk_animal_padre` FOREIGN KEY (`padre_id`) REFERENCES `animales` (`animal_id`),
  ADD CONSTRAINT `fk_animales_raza` FOREIGN KEY (`raza_id`) REFERENCES `razas` (`raza_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `animal_movimientos`
--
ALTER TABLE `animal_movimientos`
  ADD CONSTRAINT `fk_am_adest` FOREIGN KEY (`aprisco_destino_id`) REFERENCES `apriscos` (`aprisco_id`),
  ADD CONSTRAINT `fk_am_animal` FOREIGN KEY (`animal_id`) REFERENCES `animales` (`animal_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_am_aorig` FOREIGN KEY (`aprisco_origen_id`) REFERENCES `apriscos` (`aprisco_id`),
  ADD CONSTRAINT `fk_am_ardest` FOREIGN KEY (`area_destino_id`) REFERENCES `areas` (`area_id`),
  ADD CONSTRAINT `fk_am_arorig` FOREIGN KEY (`area_origen_id`) REFERENCES `areas` (`area_id`),
  ADD CONSTRAINT `fk_am_fdest` FOREIGN KEY (`finca_destino_id`) REFERENCES `fincas` (`finca_id`),
  ADD CONSTRAINT `fk_am_forig` FOREIGN KEY (`finca_origen_id`) REFERENCES `fincas` (`finca_id`),
  ADD CONSTRAINT `fk_am_recinto_destino` FOREIGN KEY (`recinto_id_destino`) REFERENCES `recintos` (`recinto_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_am_recinto_origen` FOREIGN KEY (`recinto_id_origen`) REFERENCES `recintos` (`recinto_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `animal_pesos`
--
ALTER TABLE `animal_pesos`
  ADD CONSTRAINT `fk_animal_pesos_animal` FOREIGN KEY (`animal_id`) REFERENCES `animales` (`animal_id`);

--
-- Filtros para la tabla `animal_salud`
--
ALTER TABLE `animal_salud`
  ADD CONSTRAINT `fk_animal_salud_animal` FOREIGN KEY (`animal_id`) REFERENCES `animales` (`animal_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_as_acontecimiento` FOREIGN KEY (`acontecimiento_id`) REFERENCES `acontecimiento_reportes` (`acontecimiento_id`),
  ADD CONSTRAINT `fk_salud_incidencia` FOREIGN KEY (`incidencia_id`) REFERENCES `incidencias` (`incidencia_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `animal_ubicaciones`
--
ALTER TABLE `animal_ubicaciones`
  ADD CONSTRAINT `fk_au_animal` FOREIGN KEY (`animal_id`) REFERENCES `animales` (`animal_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_au_aprisco` FOREIGN KEY (`aprisco_id`) REFERENCES `apriscos` (`aprisco_id`),
  ADD CONSTRAINT `fk_au_area` FOREIGN KEY (`area_id`) REFERENCES `areas` (`area_id`),
  ADD CONSTRAINT `fk_au_finca` FOREIGN KEY (`finca_id`) REFERENCES `fincas` (`finca_id`),
  ADD CONSTRAINT `fk_au_recinto` FOREIGN KEY (`recinto_id`) REFERENCES `recintos` (`recinto_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `areas`
--
ALTER TABLE `areas`
  ADD CONSTRAINT `fk_area_aprisco` FOREIGN KEY (`aprisco_id`) REFERENCES `apriscos` (`aprisco_id`) ON UPDATE CASCADE;
ALTER TABLE `reportes_dano` ADD `recinto_id` CHAR(50) NULL AFTER `area_id`;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
