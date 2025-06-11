# RobotRPAFramework

## 介绍
RobotRPAFramework 用于管理YOUI移动机器人自动化测试代码的仓库平台，该平台旨在简化和加速自动化测试的开发和管理的过程。

## 软件架构
该软件采用模块化设计，支持多种自动化测试框架和工具的集成，通过灵活的插件机制，用户可以根据需求扩展功能。

## 安装教程

1. 克隆仓库至本地：
   ```bash
   git clone git@gitee.com:youibot_robot/RobotRPAFramework.git
   ```
   或
   ```bash
   git clone https://gitee.com/youibot_robot/RobotRPAFramework.git
   ```
2. 进入项目目录：
   ```bash
   cd RobotRPAFramework
   ```
3. 安装依赖：
   ```bash
   npm install
   ```

## 使用说明

1. 启动测试环境：
   ```bash
   npm start
   ```
2. 运行测试：
   ```bash
   npm test
   ```
3. 查看测试报告：
   测试完成后，报告将生成在 `reports` 目录下。

## 代码规范

### 前端代码

- **文件命名**：使用小写字母和连字符（kebab-case），例如：`my-component.js`。
- **代码风格**：遵循 ESLint 规则，使用 Prettier 格式化代码。
- **组件开发**：每个组件应放在单独的文件中，使用 React Hooks 进行状态管理。
- **样式**：使用 CSS Modules 或 styled-components 进行样式管理，避免全局样式污染。

### 后端代码

- **文件命名**：使用小写字母和下划线（snake_case），例如：`my_module.py`。
- **代码风格**：遵循 PEP 8 规范，使用 Black 格式化代码。
- **模块化设计**：每个功能模块应放在单独的文件中，使用类和函数进行逻辑封装。
- **错误处理**：使用 try-except 块进行异常处理，确保程序的健壮性。

## 代码格式规划

为了确保代码的可读性和一致性，请各位开发工程师遵循以下代码格式规划：

### 通用规则

- **缩进**：使用 2 个空格进行缩进，避免使用 Tab。
- **编码**：所有文件必须使用 UTF-8 编码，确保跨平台兼容性。
- **行尾**：统一使用 LF（Linux 风格）作为行尾符号，避免不同操作系统间的冲突。
- **文件末尾空行**：所有文件末尾必须保留一个空行。
- **最大行宽标准**：每行代码不超过 80 个字符，必要时可使用换行符分隔。
- **命名规范**：
  - **变量和函数**：使用小写字母和驼峰命名法（camelCase），例如：`myFunction`。
  - **常量**：使用全大写字母和下划线分隔（SNAKE_CASE），例如：`MAX_RETRY_COUNT`。
  - **类名**：使用大写字母开头的驼峰命名法（PascalCase），例如：`MyClass`。
- **注释**：
  - 使用清晰、简洁的注释解释复杂逻辑或关键代码。
  - 单行注释使用 `//`，多行注释使用 `/* */`。
  - Python 中推荐使用 `#` 单行注释和 `"""` 多行注释。
- **空格使用**：
  - 运算符两侧保留一个空格，例如：`a + b`。
  - 函数参数列表中的逗号后保留一个空格，例如：`myFunction(a, b, c)`。
- **代码组织**：
  - 按功能模块组织代码，避免文件过于庞大。
  - 每个文件的职责单一，遵循单一职责原则（SRP）。

### 代码格式化工具说明

为了确保代码风格的一致性，建议使用以下工具进行代码格式化：

- **前端代码**：
  - 使用 [Prettier](https://prettier.io/) 和 [ESLint](https://eslint.org/)。
    - 配置文件：`.prettierrc` 和 `.eslintrc.js`。
    - 格式化命令：
      ```bash
      npx prettier --write .
      npx eslint --fix .
      ```

- **后端代码**：
  - 使用 [Black](https://black.readthedocs.io/en/stable/) 和 [isort](https://pycqa.github.io/isort/)。
    - 配置文件：`pyproject.toml`。
    - 格式化命令：
      ```bash
      black .
      isort .
      ```

- **Git 提交检查**：
  - 配置 [Husky](https://typicode.github.io/husky/) 和 [lint-staged](https://github.com/okonet/lint-staged) 实现提交前自动格式化。
    - 示例配置（`package.json`）：
      ```json
      "husky": {
        "hooks": {
          "pre-commit": "lint-staged"
        }
      },
      "lint-staged": {
        "*.js": ["eslint --fix", "prettier --write"],
        "*.py": ["black", "isort"]
      }
      ```

### 前端代码

- **JavaScript/TypeScript**：
  - 遵循 [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)。
  - 使用 ESLint 和 Prettier 自动格式化代码。
- **CSS/SCSS**：
  - 遵循 [BEM 命名规范](http://getbem.com/)。
  - 使用 CSS Modules 或 styled-components，避免全局样式污染。

### 后端代码

- **Python**：
  - 遵循 [PEP 8](https://peps.python.org/pep-0008/) 代码规范。
  - 使用 `Black` 和 `isort` 工具格式化代码。
- **日志**：
  - 使用统一的日志格式，包含时间戳、日志级别和消息内容，统一由json进行封装。

## 工程结构说明

以下是项目的目录结构及说明：

```
RobotRPAFramework/
├── src/                # 源代码目录
│   ├── web_lumen/       # 前端代码
│   │   ├── components/ # React 组件
│   │   ├── styles/     # 样式文件
│   │   └── utils/      # 前端工具函数
│   ├── cere_pro/        # 后端代码
│   │   ├── api/        # API 接口
│   │   ├── models/     # 数据模型
│   │   └── utils/      # 后端工具函数
│   └── tests/          # 测试代码
├── reports/            # 测试报告目录
├── docs/               # 文档目录
├── scripts/            # 自动化脚本
├── docker/             # Docker 配置文件目录
│   ├── Dockerfile      # Docker 镜像构建文件
│   ├── docker-compose.yml # Docker Compose 配置文件
│   └── env/            # 环境变量文件
├── .eslintrc.js        # ESLint 配置文件
├── .prettierrc         # Prettier 配置文件
├── pyproject.toml      # Python 格式化工具配置
├── package.json        # 项目依赖配置
└── README.md           # 项目说明文件
```
### 目录说明

- **`src/`**：存放项目的核心代码，分为前端和后端两部分。
  - **`web_lumen/`**：前端代码，包括 React 组件、样式文件和工具函数。
  - **`cere_pro/`**：后端代码，包括 API 接口、数据模型和工具函数。
  - **`tests/`**：测试代码，包含单元测试和集成测试。
- **`reports/`**：存放测试报告，运行测试后会自动生成。
- **`docs/`**：存放项目相关的文档，例如 API 文档、开发指南等。
- **`scripts/`**：存放自动化脚本，例如部署脚本、数据迁移脚本等。
- **`docker/`**：存放 Docker 相关配置文件。
  - **`Dockerfile`**：定义项目的 Docker 镜像构建步骤。
  - **`docker-compose.yml`**：定义多容器应用的服务、网络和卷配置。
  - **`env/`**：存放环境变量文件，例如 `.env`。
- **`.eslintrc.js`**：ESLint 配置文件，用于前端代码的静态检查。
- **`.prettierrc`**：Prettier 配置文件，用于前端代码的格式化。
- **`pyproject.toml`**：Python 格式化工具配置文件，用于后端代码的格式化。
- **`package.json`**：项目依赖配置文件，定义了前端依赖和脚本。
- **`README.md`**：项目说明文件，包含项目的基本信息和使用指南。

## 参与贡献

1. Fork 本仓库
2. 新建分支：`git checkout -b Feat_xxx`
3. 提交代码：`git commit -m 'Add some feature'`
4. 推送到分支：`git push origin Feat_xxx`
5. 提交 Pull Request

