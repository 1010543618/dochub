/*********************************************************************************
 * dochub的数据库
 *-------------------------------------------------------------------------------
 * 版权所有: dochub
***********************************************************************************/

#不设置编码cmd下中文会乱码
SET NAMES utf8;
#删除原来的kcy库
DROP DATABASE IF EXISTS dochub;
#创建kcy库
CREATE DATABASE dochub CHARSET utf8;
GRANT ALL ON dochub.* to 'dochub'@'%' IDENTIFIED BY '123456';
GRANT ALL ON dochub.* to 'dochub'@'localhost' IDENTIFIED BY '123456';
FLUSH PRIVILEGES;
SET NAMES utf8;
USE dochub;
/*-----------------创建表-----------------*/
#用户表
CREATE TABLE user (
 user_id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID',
 user_email varchar(64) NOT NULL COMMENT '用户EMAIL地址',
 user_pwd varchar(34) NOT NULL COMMENT '用户密码',
 user_name varchar(32) COMMENT '用户名',
 user_phone char(16)  COMMENT '用户手机号码0086-188xxxxxxxx',
 user_bio varchar(255) COMMENT '用户个人简介',
 user_address varchar(255) COMMENT '用户地址',
 user_regist_time timestamp NOT NULL COMMENT '注册时间，邮箱激活后为激活时间',
 activation_code char(27) NOT NULL COMMENT '激活码',
 token varchar(255) COMMENT '自动登录令牌',
 token_end_time int COMMENT '自动登录失效时间',
 PRIMARY KEY (user_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

#文档表
CREATE TABLE doc (
 doc_id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '文档ID',
 doc_name varchar(64) NOT NULL COMMENT '文档名',
 description varchar(1024) COMMENT '文档简介',
 tag varchar(255) COMMENT '标签(用","隔开)',
 default_version varchar(64) NOT NULL COMMENT '默认版本',
 versions varchar(1024) NOT NULL COMMENT '全部版本(用","隔开)',
 user_id int UNSIGNED COMMENT '创建文档的用户的ID',
 PRIMARY KEY (doc_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

#用户参与翻译文档表
CREATE TABLE participation (
 user_id int UNSIGNED NOT NULL COMMENT '用户ID',
 doc_id int UNSIGNED NOT NULL COMMENT '文档ID',
 page_para varchar(255) NOT NULL COMMENT '页面参数：/版本/...("/"为mark)',
 page_html text COMMENT '页面html',
 part_type enum('mark', 'save', 'c&t', 'proofread') NOT NULL COMMENT '类型(c&t: clear up and translate)',
 part_time int NOT NULL COMMENT '参与时间',
 vote_up smallint UNSIGNED NOT NULL DEFAULT 0 COMMENT '赞同',
 vote_down smallint UNSIGNED NOT NULL DEFAULT 0 COMMENT '否决',
 is_default enum('true','false') NOT NULL DEFAULT 'false'  COMMENT '是否为默认显示',
 is_publish enum('true','false') NOT NULL DEFAULT 'false'  COMMENT '是否为发布（保存为未发布）',
 is_delete enum('true','false') NOT NULL DEFAULT 'false'  COMMENT '是否为删除',
 PRIMARY KEY (doc_id, page_para, part_time)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

#浏览记录表
CREATE TABLE browse_record (
 user_id int UNSIGNED NOT NULL COMMENT '用户ID',
 doc_id int UNSIGNED NOT NULL COMMENT '文档ID',
 browse_times int NOT NULL COMMENT '浏览次数',
 last_browse_time timestamp NOT NULL COMMENT '上次浏览时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

#收藏表
CREATE TABLE collection (
 user_id int UNSIGNED NOT NULL COMMENT '用户ID',
 doc_id int UNSIGNED NOT NULL COMMENT '文档ID',
 collect_time timestamp NOT NULL COMMENT '收藏时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*-----------------插入数据-----------------*/
INSERT INTO user 
(user_id, user_email, user_name, user_pwd, user_regist_time, activation_code) 
VALUES 
(1, 'admin@163.com', 'admin', '$1$12345678$a4ge4d5iJ5vwvbFS88TEN0', now(), '0');

INSERT INTO doc 
(doc_id, doc_name, default_version, versions, description) 
VALUES 
(1,"bootstrap", "v4.0", "v4.0", "Bootstrap是一个用HTML，CSS和JS开发的开源工具包。使用我们的Sass变量和mixins，响应式网格系统，大量预构建组件以及基于jQuery构建的强大插件，快速构建原型或构建整个应用程序。");
-- (2,"react","React is a JavaScript library for building user interfaces."),
-- (3,"react-dom","The entry point of the DOM-related rendering paths. It is intended to be paired with the isomorphic React, which is shipped as react to npm."),
-- (4,"vue","Simple, Fast & Composable MVVM for building interactive interfaces"),
-- (5,"d3","A JavaScript visualization library for HTML and SVG."),
-- (6,"angular.js","AngularJS is an MVC framework for building web applications. The core features include HTML enhanced with custom component and data-binding capabilities, dependency injection and strong focus on simplicity, testability, maintainability and boiler-plate reduction."),
-- (7,"angular-touch","AngularJS module for touch events and helpers for touch-enabled devices"),
-- (8,"angular-sanitize","AngularJS module for sanitizing HTML"),
-- (9,"angular-resource","AngularJS module for interacting with RESTful server-side data sources")

INSERT INTO browse_record 
(user_id, doc_id, browse_times, last_browse_time) 
VALUES 
(1, 1, 3, now()),
(1, 2, 3, now()),
(1, 3, 3, now()),
(1, 4, 3, now());

INSERT INTO participation 
(user_id, doc_id, page_para, part_type, part_time) 
VALUES 
(1, 5, '/index.html', 'c&t', UNIX_TIMESTAMP()),
(1, 6, '/', 'mark', UNIX_TIMESTAMP()),
(1, 6, '/haha.html', 'c&t', UNIX_TIMESTAMP()),
(1, 6, '/haha.html', 'proofread', UNIX_TIMESTAMP()+1),
(1, 7, '/', 'mark', UNIX_TIMESTAMP()),
(1, 8, '/', 'mark', UNIX_TIMESTAMP());

INSERT INTO collection 
(user_id, doc_id, collect_time)
VALUES 
(1, 1, now()),
(1, 2, now()),
(1, 3, now()),
(1, 9, now());




