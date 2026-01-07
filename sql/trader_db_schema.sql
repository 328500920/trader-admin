
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ai_usage_quota
-- ----------------------------
DROP TABLE IF EXISTS `ai_usage_quota`;
CREATE TABLE `ai_usage_quota`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `usage_date` date NOT NULL COMMENT '使用日期',
  `used_count` int(11) NULL DEFAULT 0 COMMENT '已使用次数',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_date`(`user_id`, `usage_date`) USING BTREE,
  INDEX `idx_usage_date`(`usage_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AI使用次数配额';

-- ----------------------------
-- Table structure for community_comment
-- ----------------------------
DROP TABLE IF EXISTS `community_comment`;
CREATE TABLE `community_comment`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `post_id` bigint(20) NOT NULL COMMENT '帖子ID',
  `user_id` bigint(20) NOT NULL COMMENT '评论者ID',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父评论ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '评论内容',
  `like_count` int(11) NULL DEFAULT 0 COMMENT '点赞数',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_post_id`(`post_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '评论表';

-- ----------------------------
-- Table structure for community_like
-- ----------------------------
DROP TABLE IF EXISTS `community_like`;
CREATE TABLE `community_like`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `target_type` tinyint(4) NOT NULL COMMENT '目标类型：1帖子 2评论',
  `target_id` bigint(20) NOT NULL COMMENT '目标ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_target`(`user_id`, `target_type`, `target_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '点赞表';

-- ----------------------------
-- Table structure for community_post
-- ----------------------------
DROP TABLE IF EXISTS `community_post`;
CREATE TABLE `community_post`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '帖子ID',
  `user_id` bigint(20) NOT NULL COMMENT '作者ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '内容',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分类',
  `view_count` int(11) NULL DEFAULT 0 COMMENT '浏览量',
  `like_count` int(11) NULL DEFAULT 0 COMMENT '点赞数',
  `comment_count` int(11) NULL DEFAULT 0 COMMENT '评论数',
  `is_top` tinyint(4) NULL DEFAULT 0 COMMENT '是否置顶',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_category`(`category`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '帖子表';

-- ----------------------------
-- Table structure for crypto_currency
-- ----------------------------
DROP TABLE IF EXISTS `crypto_currency`;
CREATE TABLE `crypto_currency`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '货币代码，如BTC',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '货币名称，如Bitcoin',
  `name_cn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '中文名称，如比特币',
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '图标URL',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序权重，越小越靠前',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 1启用 0禁用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_code`(`code`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_sort`(`sort_order`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '数字货币码表';

-- ----------------------------
-- Table structure for glossary_category
-- ----------------------------
DROP TABLE IF EXISTS `glossary_category`;
CREATE TABLE `glossary_category`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '分类名称',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '图标',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父分类ID',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 1启用 0禁用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent_id`(`parent_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '术语分类表';

-- ----------------------------
-- Table structure for glossary_favorite
-- ----------------------------
DROP TABLE IF EXISTS `glossary_favorite`;
CREATE TABLE `glossary_favorite`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `term_id` bigint(20) NOT NULL COMMENT '术语ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_term`(`user_id`, `term_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '术语收藏表';

-- ----------------------------
-- Table structure for glossary_history
-- ----------------------------
DROP TABLE IF EXISTS `glossary_history`;
CREATE TABLE `glossary_history`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `term_id` bigint(20) NOT NULL COMMENT '术语ID',
  `view_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '查看时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_view_time`(`view_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '术语查看历史表';

-- ----------------------------
-- Table structure for glossary_term
-- ----------------------------
DROP TABLE IF EXISTS `glossary_term`;
CREATE TABLE `glossary_term`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '术语名称',
  `name_en` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '英文名称',
  `category_id` bigint(20) NOT NULL COMMENT '分类ID',
  `brief` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '简短定义',
  `detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '详细解释(Markdown)',
  `application` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '应用场景(Markdown)',
  `example` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '示例(Markdown)',
  `related_terms` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '相关术语ID(JSON数组)',
  `related_chapters` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '关联课程章节ID(JSON数组)',
  `difficulty` tinyint(4) NULL DEFAULT 1 COMMENT '难度: 1入门 2进阶 3高级',
  `tags` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '标签(JSON数组)',
  `pinyin` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '拼音(用于搜索)',
  `view_count` int(11) NULL DEFAULT 0 COMMENT '查看次数',
  `favorite_count` int(11) NULL DEFAULT 0 COMMENT '收藏次数',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 1启用 0禁用',
  `create_by` bigint(20) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category_id`(`category_id`) USING BTREE,
  INDEX `idx_difficulty`(`difficulty`) USING BTREE,
  INDEX `idx_name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '术语表';

-- ----------------------------
-- Table structure for learn_case
-- ----------------------------
DROP TABLE IF EXISTS `learn_case`;
CREATE TABLE `learn_case`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '案例ID',
  `chapter_id` bigint(20) NOT NULL COMMENT '章节ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '案例标题',
  `case_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'success' COMMENT '案例类型：success成功/failure失败/analysis分析',
  `symbol` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易品种：BTC/ETH等',
  `timeframe` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '时间周期：1H/4H/1D等',
  `entry_date` date NULL DEFAULT NULL COMMENT '入场日期',
  `background` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '案例背景',
  `analysis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '分析过程',
  `entry_setup` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '入场设置',
  `result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '实际结果',
  `lessons` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '经验总结',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '完整案例内容(Markdown)',
  `image_urls` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '图片链接JSON数组',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态：0禁用 1启用',
  `create_by` bigint(20) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_chapter_id`(`chapter_id`) USING BTREE,
  INDEX `idx_symbol`(`symbol`) USING BTREE,
  INDEX `idx_case_type`(`case_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 73 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '实战案例表';

-- ----------------------------
-- Table structure for learn_chapter
-- ----------------------------
DROP TABLE IF EXISTS `learn_chapter`;
CREATE TABLE `learn_chapter`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '章节ID',
  `course_id` bigint(20) NOT NULL COMMENT '课程ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '章节标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '章节内容（Markdown）',
  `week_number` int(11) NULL DEFAULT NULL COMMENT '周数',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_course_id`(`course_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '章节表';

-- ----------------------------
-- Table structure for learn_checkin
-- ----------------------------
DROP TABLE IF EXISTS `learn_checkin`;
CREATE TABLE `learn_checkin`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `checkin_date` date NOT NULL COMMENT '打卡日期',
  `study_minutes` int(11) NULL DEFAULT 0 COMMENT '学习时长(分钟)',
  `chapters_completed` int(11) NULL DEFAULT 0 COMMENT '完成章节数',
  `quizzes_completed` int(11) NULL DEFAULT 0 COMMENT '完成测验数',
  `cases_viewed` int(11) NULL DEFAULT 0 COMMENT '查看案例数',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_date`(`user_id`, `checkin_date`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_checkin_date`(`checkin_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学习打卡记录';

-- ----------------------------
-- Table structure for learn_course
-- ----------------------------
DROP TABLE IF EXISTS `learn_course`;
CREATE TABLE `learn_course`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '课程ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '课程标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '课程描述',
  `cover_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '封面图片',
  `stage` int(11) NOT NULL COMMENT '阶段：1/2/3',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态：0草稿 1发布',
  `create_by` bigint(20) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_stage`(`stage`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程表';

-- ----------------------------
-- Table structure for learn_material
-- ----------------------------
DROP TABLE IF EXISTS `learn_material`;
CREATE TABLE `learn_material`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '资料ID',
  `chapter_id` bigint(20) NOT NULL COMMENT '章节ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '资料标题',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '资料描述',
  `material_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '资料类型：markdown/pdf/video/link',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '资料内容（markdown类型）',
  `file_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件URL（pdf/video类型）',
  `link_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '外部链接（link类型）',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态：0禁用 1启用',
  `create_by` bigint(20) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_chapter_id`(`chapter_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学习资料表';

-- ----------------------------
-- Table structure for learn_note
-- ----------------------------
DROP TABLE IF EXISTS `learn_note`;
CREATE TABLE `learn_note`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '笔记ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `chapter_id` bigint(20) NULL DEFAULT NULL COMMENT '关联章节ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '笔记标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '笔记内容',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学习笔记表';

-- ----------------------------
-- Table structure for learn_progress
-- ----------------------------
DROP TABLE IF EXISTS `learn_progress`;
CREATE TABLE `learn_progress`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `chapter_id` bigint(20) NOT NULL COMMENT '章节ID',
  `is_completed` tinyint(4) NULL DEFAULT 0 COMMENT '是否完成',
  `complete_time` datetime NULL DEFAULT NULL COMMENT '完成时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_chapter`(`user_id`, `chapter_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学习进度表';

-- ----------------------------
-- Table structure for learn_quiz
-- ----------------------------
DROP TABLE IF EXISTS `learn_quiz`;
CREATE TABLE `learn_quiz`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '题目ID',
  `chapter_id` bigint(20) NOT NULL COMMENT '章节ID',
  `question` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '题目内容',
  `question_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '题型：single单选/multiple多选/judge判断/calculate计算/short简答',
  `options` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '选项JSON：[{\"key\":\"A\",\"value\":\"选项内容\"}]',
  `answer` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '正确答案：A/AB/true/false/具体答案',
  `explanation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '答案解析',
  `difficulty` tinyint(4) NULL DEFAULT 1 COMMENT '难度：1基础 2进阶 3挑战',
  `points` int(11) NULL DEFAULT 10 COMMENT '分值',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态：0禁用 1启用',
  `create_by` bigint(20) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_chapter_id`(`chapter_id`) USING BTREE,
  INDEX `idx_question_type`(`question_type`) USING BTREE,
  INDEX `idx_difficulty`(`difficulty`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 289 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '测验题目表';

-- ----------------------------
-- Table structure for learn_quiz_record
-- ----------------------------
DROP TABLE IF EXISTS `learn_quiz_record`;
CREATE TABLE `learn_quiz_record`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `chapter_id` bigint(20) NOT NULL COMMENT '章节ID',
  `total_questions` int(11) NULL DEFAULT 0 COMMENT '总题数',
  `correct_count` int(11) NULL DEFAULT 0 COMMENT '正确数',
  `score` int(11) NULL DEFAULT 0 COMMENT '得分',
  `time_spent` int(11) NULL DEFAULT NULL COMMENT '用时(秒)',
  `answers` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '答题详情JSON',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_chapter_id`(`chapter_id`) USING BTREE,
  INDEX `idx_user_chapter`(`user_id`, `chapter_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户测验记录表';

-- ----------------------------
-- Table structure for learn_resource
-- ----------------------------
DROP TABLE IF EXISTS `learn_resource`;
CREATE TABLE `learn_resource`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '资源ID',
  `chapter_id` bigint(20) NOT NULL COMMENT '章节ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '资源标题',
  `resource_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '资源类型：video视频/article文章/tool工具/chart图表/book书籍/report报告',
  `platform` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '平台：youtube/bilibili/tradingview/medium等',
  `url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '资源链接',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '资源描述',
  `author` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '作者/来源',
  `language` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'zh' COMMENT '语言：zh中文/en英文',
  `is_free` tinyint(4) NULL DEFAULT 1 COMMENT '是否免费：0付费 1免费',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态：0禁用 1启用',
  `create_by` bigint(20) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_chapter_id`(`chapter_id`) USING BTREE,
  INDEX `idx_resource_type`(`resource_type`) USING BTREE,
  INDEX `idx_platform`(`platform`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 97 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '外部资源表';

-- ----------------------------
-- Table structure for learn_task
-- ----------------------------
DROP TABLE IF EXISTS `learn_task`;
CREATE TABLE `learn_task`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `chapter_id` bigint(20) NOT NULL COMMENT '章节ID',
  `task_content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务内容',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_chapter_id`(`chapter_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 151 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学习任务表';

-- ----------------------------
-- Table structure for learn_task_record
-- ----------------------------
DROP TABLE IF EXISTS `learn_task_record`;
CREATE TABLE `learn_task_record`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `task_id` bigint(20) NOT NULL COMMENT '任务ID',
  `is_completed` tinyint(4) NULL DEFAULT 0 COMMENT '是否完成',
  `complete_time` datetime NULL DEFAULT NULL COMMENT '完成时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_task`(`user_id`, `task_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '任务完成记录表';

-- ----------------------------
-- Table structure for learn_tool_guide
-- ----------------------------
DROP TABLE IF EXISTS `learn_tool_guide`;
CREATE TABLE `learn_tool_guide`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '指南ID',
  `tool_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '工具名称',
  `tool_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '工具类型：chart图表/exchange交易所/data数据/sentiment情绪/record记录',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '工具描述',
  `official_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '官方网址',
  `logo_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Logo图片',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '使用指南(Markdown)',
  `features` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '主要功能JSON数组',
  `pros` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '优点',
  `cons` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '缺点',
  `pricing` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '价格说明',
  `difficulty` tinyint(4) NULL DEFAULT 1 COMMENT '上手难度：1简单 2中等 3复杂',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态：0禁用 1启用',
  `create_by` bigint(20) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tool_type`(`tool_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '工具指南表';

-- ----------------------------
-- Table structure for learn_topic
-- ----------------------------
DROP TABLE IF EXISTS `learn_topic`;
CREATE TABLE `learn_topic`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '专题ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '专题标题',
  `subtitle` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '副标题',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '专题描述',
  `cover_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '封面图片',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '专题内容(Markdown)',
  `topic_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '专题类型：supplement补充/advanced进阶/special专题',
  `related_week` int(11) NULL DEFAULT NULL COMMENT '关联周数(可选)',
  `difficulty` tinyint(4) NULL DEFAULT 2 COMMENT '难度：1入门 2进阶 3高级',
  `estimated_time` int(11) NULL DEFAULT NULL COMMENT '预计学习时间(分钟)',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态：0草稿 1发布',
  `create_by` bigint(20) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_topic_type`(`topic_type`) USING BTREE,
  INDEX `idx_related_week`(`related_week`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '专题内容表';

-- ----------------------------
-- Table structure for learn_video_course
-- ----------------------------
DROP TABLE IF EXISTS `learn_video_course`;
CREATE TABLE `learn_video_course`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '视频标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '视频描述',
  `cover_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '封面图URL',
  `video_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '视频URL',
  `duration` int(11) NULL DEFAULT 0 COMMENT '视频时长(秒)',
  `file_size` bigint(20) NULL DEFAULT 0 COMMENT '文件大小(字节)',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分类',
  `tags` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签，逗号分隔',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT 0 COMMENT '状态: 0草稿 1发布',
  `view_count` int(11) NULL DEFAULT 0 COMMENT '观看次数',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category`(`category`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_sort_order`(`sort_order`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '视频课程表';

-- ----------------------------
-- Table structure for learn_video_progress
-- ----------------------------
DROP TABLE IF EXISTS `learn_video_progress`;
CREATE TABLE `learn_video_progress`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `video_id` bigint(20) NOT NULL COMMENT '视频ID',
  `progress` int(11) NULL DEFAULT 0 COMMENT '观看进度(秒)',
  `is_completed` tinyint(4) NULL DEFAULT 0 COMMENT '是否看完: 0否 1是',
  `watch_count` int(11) NULL DEFAULT 1 COMMENT '观看次数',
  `last_watch_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最后观看时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_video`(`user_id`, `video_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_video_id`(`video_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '视频观看进度表';

-- ----------------------------
-- Table structure for learn_wrong_question
-- ----------------------------
DROP TABLE IF EXISTS `learn_wrong_question`;
CREATE TABLE `learn_wrong_question`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `quiz_id` bigint(20) NOT NULL COMMENT '题目ID',
  `wrong_count` int(11) NULL DEFAULT 1 COMMENT '错误次数',
  `last_wrong_time` datetime NULL DEFAULT NULL COMMENT '最近错误时间',
  `is_mastered` tinyint(4) NULL DEFAULT 0 COMMENT '是否已掌握',
  `mastered_time` datetime NULL DEFAULT NULL COMMENT '掌握时间',
  `user_answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '用户答案',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_quiz`(`user_id`, `quiz_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_quiz_id`(`quiz_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '错题记录';

-- ----------------------------
-- Table structure for psychology_daily
-- ----------------------------
DROP TABLE IF EXISTS `psychology_daily`;
CREATE TABLE `psychology_daily`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `record_date` date NOT NULL COMMENT '记录日期',
  `mood_score` int(11) NOT NULL COMMENT '整体情绪1-10',
  `mood_tags` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '情绪标签(JSON数组)',
  `sleep_quality` tinyint(4) NULL DEFAULT NULL COMMENT '睡眠质量: 1很差-5很好',
  `physical_state` tinyint(4) NULL DEFAULT NULL COMMENT '身体状态: 1疲惫 2一般 3精力充沛',
  `external_pressure` int(11) NULL DEFAULT NULL COMMENT '外部压力1-10',
  `traps` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '触发的心理陷阱(JSON数组)',
  `daily_plan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '今日计划',
  `daily_reflection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '今日反思',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_date`(`user_id`, `record_date`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_record_date`(`record_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '每日情绪记录表';

-- ----------------------------
-- Table structure for psychology_trade
-- ----------------------------
DROP TABLE IF EXISTS `psychology_trade`;
CREATE TABLE `psychology_trade`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `trade_log_id` bigint(20) NULL DEFAULT NULL COMMENT '关联交易记录ID',
  `record_date` date NOT NULL COMMENT '记录日期',
  `entry_mood` int(11) NULL DEFAULT NULL COMMENT '开仓情绪1-10',
  `holding_mood` int(11) NULL DEFAULT NULL COMMENT '持仓情绪1-10',
  `exit_mood` int(11) NULL DEFAULT NULL COMMENT '平仓情绪1-10',
  `traps` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '触发的心理陷阱(JSON数组)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '情绪描述',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_trade_log_id`(`trade_log_id`) USING BTREE,
  INDEX `idx_record_date`(`record_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '交易情绪记录表';

-- ----------------------------
-- Table structure for sys_ai_model
-- ----------------------------
DROP TABLE IF EXISTS `sys_ai_model`;
CREATE TABLE `sys_ai_model`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模型名称(显示用)',
  `provider` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '提供商: deepseek/qwen',
  `model` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模型标识: deepseek-chat/qwen-turbo',
  `api_url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'API地址',
  `api_key` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'API密钥',
  `max_tokens` int(11) NULL DEFAULT 4096 COMMENT '最大token数',
  `temperature` decimal(2, 1) NULL DEFAULT 0.7 COMMENT '温度参数',
  `is_active` tinyint(4) NULL DEFAULT 0 COMMENT '是否启用: 0否 1是(只能有一个启用)',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_provider`(`provider`) USING BTREE,
  INDEX `idx_is_active`(`is_active`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AI模型配置表';

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父菜单ID，0表示顶级菜单',
  `menu_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单唯一标识，对应前端路由name',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单显示名称',
  `path` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '路由路径',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '菜单图标',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序序号，越小越靠前',
  `visible` tinyint(4) NULL DEFAULT 1 COMMENT '是否显示：1-显示 0-隐藏（全局隐藏）',
  `role_admin` tinyint(4) NULL DEFAULT 1 COMMENT '管理员可见：1-是 0-否',
  `role_teacher` tinyint(4) NULL DEFAULT 1 COMMENT '教师可见：1-是 0-否',
  `role_student` tinyint(4) NULL DEFAULT 1 COMMENT '学员可见：1-是 0-否',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_menu_key`(`menu_key`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 55 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统菜单表';

-- ----------------------------
-- Table structure for sys_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_operation_log`;
CREATE TABLE `sys_operation_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '操作用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户名',
  `operation_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作类型: LOGIN/LOGOUT/CREATE/UPDATE/DELETE/IMPORT/EXPORT',
  `module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '功能模块',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作描述',
  `method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求方法: GET/POST/PUT/DELETE',
  `request_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求URL',
  `request_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求参数(JSON)',
  `response_code` int(11) NULL DEFAULT NULL COMMENT '响应状态码',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作IP',
  `user_agent` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '浏览器信息',
  `execution_time` bigint(20) NULL DEFAULT NULL COMMENT '执行耗时(毫秒)',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '操作状态: 1成功 0失败',
  `error_msg` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '错误信息',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_operation_type`(`operation_type`) USING BTREE,
  INDEX `idx_module`(`module`) USING BTREE,
  INDEX `idx_created_at`(`created_at`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 108 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '操作日志表';

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色编码',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态：0禁用 1启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `role_code`(`role_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色表';

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '头像URL',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `role_id` bigint(20) NULL DEFAULT 0 COMMENT '角色ID',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态：0禁用 1启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'student' COMMENT '角色: admin/teacher/student',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE,
  INDEX `idx_username`(`username`) USING BTREE,
  INDEX `idx_role_id`(`role_id`) USING BTREE,
  INDEX `idx_role`(`role`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表';

-- ----------------------------
-- Table structure for tool_checklist
-- ----------------------------
DROP TABLE IF EXISTS `tool_checklist`;
CREATE TABLE `tool_checklist`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '清单名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `items` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '清单项JSON',
  `is_system` tinyint(4) NULL DEFAULT 0 COMMENT '是否系统预设',
  `create_by` bigint(20) NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '检查清单模板表';

-- ----------------------------
-- Table structure for tool_daily_analysis
-- ----------------------------
DROP TABLE IF EXISTS `tool_daily_analysis`;
CREATE TABLE `tool_daily_analysis`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `analysis_date` date NOT NULL COMMENT '分析日期',
  `macro_events` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '今日重要事件',
  `fed_attitude` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '美联储态度',
  `dxy_trend` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'DXY趋势',
  `stock_trend` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '美股走势',
  `exchange_flow` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易所流向',
  `whale_action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '巨鲸动向',
  `fear_greed_index` int(11) NULL DEFAULT NULL COMMENT '恐惧贪婪指数',
  `funding_rate` decimal(10, 4) NULL DEFAULT NULL COMMENT '资金费率',
  `long_short_ratio` decimal(10, 4) NULL DEFAULT NULL COMMENT '多空比',
  `btc_price` decimal(20, 8) NULL DEFAULT NULL COMMENT 'BTC价格',
  `weekly_trend` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '周线趋势',
  `daily_trend` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '日线趋势',
  `key_support` decimal(20, 8) NULL DEFAULT NULL COMMENT '关键支撑',
  `key_resistance` decimal(20, 8) NULL DEFAULT NULL COMMENT '关键阻力',
  `overall_score` int(11) NULL DEFAULT NULL COMMENT '综合评分',
  `market_view` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '市场观点',
  `today_strategy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '今日策略',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_date`(`user_id`, `analysis_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '每日分析记录表';

-- ----------------------------
-- Table structure for tool_link
-- ----------------------------
DROP TABLE IF EXISTS `tool_link`;
CREATE TABLE `tool_link`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '链接名称',
  `url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '链接地址',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图标',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分类',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '常用链接表';

-- ----------------------------
-- Table structure for trade_image
-- ----------------------------
DROP TABLE IF EXISTS `trade_image`;
CREATE TABLE `trade_image`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `trade_id` bigint(20) NOT NULL COMMENT '交易ID',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '图片URL',
  `image_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片类型',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片描述',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_trade_id`(`trade_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '交易截图表';

-- ----------------------------
-- Table structure for trade_log
-- ----------------------------
DROP TABLE IF EXISTS `trade_log`;
CREATE TABLE `trade_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '交易ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `trade_date` date NOT NULL COMMENT '交易日期',
  `symbol` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '交易品种',
  `direction` tinyint(4) NOT NULL COMMENT '方向：1做多 2做空',
  `strategy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '使用策略',
  `entry_price` decimal(20, 8) NOT NULL COMMENT '入场价格',
  `entry_time` datetime NULL DEFAULT NULL COMMENT '入场时间',
  `entry_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '入场理由',
  `exit_price` decimal(20, 8) NULL DEFAULT NULL COMMENT '出场价格',
  `exit_time` datetime NULL DEFAULT NULL COMMENT '出场时间',
  `exit_reason` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '出场原因',
  `stop_loss` decimal(20, 8) NULL DEFAULT NULL COMMENT '止损价',
  `take_profit` decimal(20, 8) NULL DEFAULT NULL COMMENT '止盈价',
  `position_size` decimal(20, 8) NULL DEFAULT NULL COMMENT '仓位大小',
  `profit_loss` decimal(20, 8) NULL DEFAULT NULL COMMENT '盈亏金额',
  `profit_loss_percent` decimal(10, 4) NULL DEFAULT NULL COMMENT '盈亏百分比',
  `status` tinyint(4) NULL DEFAULT 0 COMMENT '状态：0持仓中 1已平仓',
  `macro_analysis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '宏观分析',
  `chain_analysis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '链上分析',
  `sentiment_analysis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '情绪分析',
  `technical_analysis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '技术分析',
  `review` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '交易复盘',
  `emotion_score` int(11) NULL DEFAULT NULL COMMENT '情绪评分',
  `discipline_followed` tinyint(4) NULL DEFAULT NULL COMMENT '是否遵守纪律',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_trade_date`(`trade_date`) USING BTREE,
  INDEX `idx_symbol`(`symbol`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '交易日志表';

-- ----------------------------
-- Table structure for trade_plan
-- ----------------------------
DROP TABLE IF EXISTS `trade_plan`;
CREATE TABLE `trade_plan`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `symbol` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '交易对',
  `direction` tinyint(4) NOT NULL COMMENT '方向: 1做多 2做空',
  `plan_time` datetime NULL DEFAULT NULL COMMENT '计划执行时间',
  `entry_price` decimal(20, 8) NOT NULL COMMENT '入场价格',
  `stop_loss_price` decimal(20, 8) NOT NULL COMMENT '止损价格',
  `take_profit_1` decimal(20, 8) NULL DEFAULT NULL COMMENT '止盈目标1',
  `take_profit_2` decimal(20, 8) NULL DEFAULT NULL COMMENT '止盈目标2',
  `take_profit_3` decimal(20, 8) NULL DEFAULT NULL COMMENT '止盈目标3',
  `position_ratio` decimal(5, 2) NULL DEFAULT NULL COMMENT '仓位比例%',
  `leverage` int(11) NULL DEFAULT 1 COMMENT '杠杆倍数',
  `risk_amount` decimal(20, 8) NULL DEFAULT NULL COMMENT '风险金额',
  `entry_reasons` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '入场理由(JSON数组)',
  `technical_signals` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '技术信号(JSON数组)',
  `market_trend` tinyint(4) NULL DEFAULT NULL COMMENT '市场趋势: 1上涨 2震荡 3下跌',
  `confidence` int(11) NULL DEFAULT NULL COMMENT '信心指数1-10',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '备注',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 1待执行 2已执行 3已取消 4已过期',
  `execute_time` datetime NULL DEFAULT NULL COMMENT '实际执行时间',
  `trade_log_id` bigint(20) NULL DEFAULT NULL COMMENT '关联交易记录ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_plan_time`(`plan_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '交易计划表';

-- ----------------------------
-- Table structure for trade_position
-- ----------------------------
DROP TABLE IF EXISTS `trade_position`;
CREATE TABLE `trade_position`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `symbol` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '合约',
  `margin_mode` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '保证金模式 Isolated/Cross',
  `position_side` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '方向 Long/Short',
  `entry_price` decimal(20, 8) NOT NULL COMMENT '入场均价',
  `close_price` decimal(20, 8) NULL DEFAULT NULL COMMENT '平仓均价',
  `max_quantity` decimal(20, 8) NULL DEFAULT NULL COMMENT '最大持仓量',
  `closed_quantity` decimal(20, 8) NULL DEFAULT NULL COMMENT '平仓数量',
  `closing_pnl` decimal(20, 8) NULL DEFAULT NULL COMMENT '平仓盈亏',
  `open_time` datetime NULL DEFAULT NULL COMMENT '开仓时间',
  `close_time` datetime NULL DEFAULT NULL COMMENT '平仓时间',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态 Closed/Open',
  `trade_log_id` bigint(20) NULL DEFAULT NULL COMMENT '关联的交易日志ID',
  `source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'BINANCE' COMMENT '数据来源',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_time`(`user_id`, `open_time`) USING BTREE,
  INDEX `idx_symbol`(`symbol`) USING BTREE,
  INDEX `idx_trade_log`(`trade_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 85 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '仓位历史表';

-- ----------------------------
-- Table structure for trade_record
-- ----------------------------
DROP TABLE IF EXISTS `trade_record`;
CREATE TABLE `trade_record`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `trade_time` datetime NOT NULL COMMENT '成交时间(北京时间)',
  `symbol` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '合约/交易对',
  `direction` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '方向: 买入/卖出',
  `price` decimal(20, 8) NOT NULL COMMENT '成交价格',
  `quantity` decimal(20, 8) NOT NULL COMMENT '成交数量',
  `amount` decimal(20, 8) NOT NULL COMMENT '成交额',
  `fee` decimal(20, 8) NULL DEFAULT NULL COMMENT '手续费',
  `fee_currency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手续费结算币种',
  `realized_pnl` decimal(20, 8) NULL DEFAULT NULL COMMENT '已实现盈亏',
  `quote_asset` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '计价资产',
  `source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'BINANCE' COMMENT '数据来源',
  `trade_log_id` bigint(20) NULL DEFAULT NULL COMMENT '关联的交易日志ID',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_time`(`user_id`, `trade_time`) USING BTREE,
  INDEX `idx_symbol`(`symbol`) USING BTREE,
  INDEX `idx_trade_log`(`trade_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 98 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '成交记录表';

-- ----------------------------
-- Table structure for trade_summary
-- ----------------------------
DROP TABLE IF EXISTS `trade_summary`;
CREATE TABLE `trade_summary`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `summary_month` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '统计月份',
  `total_trades` int(11) NULL DEFAULT 0 COMMENT '总交易次数',
  `win_trades` int(11) NULL DEFAULT 0 COMMENT '盈利次数',
  `lose_trades` int(11) NULL DEFAULT 0 COMMENT '亏损次数',
  `win_rate` decimal(5, 2) NULL DEFAULT NULL COMMENT '胜率',
  `total_profit` decimal(20, 8) NULL DEFAULT 0.00000000 COMMENT '总盈利',
  `total_loss` decimal(20, 8) NULL DEFAULT 0.00000000 COMMENT '总亏损',
  `net_profit` decimal(20, 8) NULL DEFAULT 0.00000000 COMMENT '净盈亏',
  `profit_factor` decimal(10, 4) NULL DEFAULT NULL COMMENT '盈亏比',
  `max_profit` decimal(20, 8) NULL DEFAULT NULL COMMENT '最大单笔盈利',
  `max_loss` decimal(20, 8) NULL DEFAULT NULL COMMENT '最大单笔亏损',
  `max_drawdown` decimal(10, 4) NULL DEFAULT NULL COMMENT '最大回撤',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_month`(`user_id`, `summary_month`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '绩效汇总表';

-- ----------------------------
-- Table structure for trade_xray_report
-- ----------------------------
DROP TABLE IF EXISTS `trade_xray_report`;
CREATE TABLE `trade_xray_report`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `model_id` bigint(20) NULL DEFAULT NULL COMMENT '使用的模型ID',
  `model_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '使用的模型名称',
  `start_date` date NOT NULL COMMENT '分析开始日期',
  `end_date` date NOT NULL COMMENT '分析结束日期',
  `trade_count` int(11) NULL DEFAULT 0 COMMENT '成交记录数',
  `position_count` int(11) NULL DEFAULT 0 COMMENT '仓位数',
  `total_score` int(11) NULL DEFAULT NULL COMMENT '综合评分(0-100)',
  `win_rate` decimal(5, 2) NULL DEFAULT NULL COMMENT '胜率',
  `profit_loss_ratio` decimal(5, 2) NULL DEFAULT NULL COMMENT '盈亏比',
  `risk_score` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '风控评分',
  `discipline_score` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '纪律评分',
  `strengths` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '优势(JSON数组)',
  `problems` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '问题(JSON数组)',
  `suggestions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '建议(JSON数组)',
  `full_report` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '完整AI报告',
  `statistics` json NULL COMMENT '详细统计数据',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '交易X光分析报告';

-- ----------------------------
-- Table structure for user_favorite
-- ----------------------------
DROP TABLE IF EXISTS `user_favorite`;
CREATE TABLE `user_favorite`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `target_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '收藏类型: case/resource/topic/quiz/tool',
  `target_id` bigint(20) NOT NULL COMMENT '收藏目标ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_target`(`user_id`, `target_type`, `target_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_target`(`target_type`, `target_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户收藏';

SET FOREIGN_KEY_CHECKS = 1;
