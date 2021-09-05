# Tomcat アプリケーションプロビジョニング環境
\* [英語版](/README.md)

## 1. 概要
本プロジェクトは、Tomcatアプリケーション [(spring-mvc-example)](https://github.com/d-saitou/spring-mvc-example) のプロビジョニング環境です。  
本プロビジョニング環境は以下の操作を実行します。

* 仮想マシン構築
* ゲストOS及び必要なソフトウェア類のセットアップ
* アプリケーションのビルド/デプロイ
* データベース構築


## 2. 説明
本プロビジョニング環境は、プロビジョニングを実行するために以下のツールを使用しています。

* プロビジョニング
  - Vagrant (+シェルスクリプト)
  - Ansible
* ビルド/デプロイ
  - Maven
  - Jenkins

### 2.1. セットアップ内容
本プロビジョニング環境は以下の手順でプロビジョニングを実行します。  

<div style="text-align: center;">
	<img src="https://github.com/d-saitou/provisioning-environment-for-tomcat8/blob/images/ProvisioningProcedure.ja.jpg">
</div>

### 2.2. 認証情報及びURL

**[OS]**

| ユーザー名 | パスワード | ホームディレクトリ | 備考                               |
|:-----------|:-----------|:-------------------|:-----------------------------------|
| vagrant    | vagrant    | /home/vagrant      | Vagrant用仮想マシンのユーザー      |
| tomcat     | tomcat     | \-                 | Tomcat起動ユーザー                 |
| apps       | apps       | /apps              | アプリケーション関連ファイルを保存 |

**[アプリケーション]**

| アプリケーション   | ユーザー | パスワード | URL                                       | 備考         |
|:-------------------|:---------|:-----------|:------------------------------------------|:-------------|
| MySQL              | root     | Adm1N@1234 | \-                                        |              |
|                    | example  | example    | \*Database: example                       |              |
| Tomcat Manager     | admin    | admin      | http://{ip-addr}:8080/manager/            |              |
| spring-mvc-example | admin    | admin      | http://{ip-addr}:8080/spring-mvc-example/ | 管理者       |
|                    | user     | user       |                                           | 一般ユーザー |
| Jenkins            | admin    | admin      | http://{ip-addr}:18080/jenkins/           |              |
| maildev            | \-       | \-         | http://{ip-addr}:1080/                    |              |

### 2.3. ディレクトリ構成

| パス          | 説明                                                                           |
|:--------------|:-------------------------------------------------------------------------------|
| /opt/tomcat   | Tomcatインストールディレクトリ                                                 |
| /opt/maven    | Mavenインストールディレクトリ                                                  |
| /apps         | "apps"ユーザーのホームディレクトリ                                             |
| /apps/bin     | バッチやシェルスクリプト等の実行ファイルを格納                                 |
| /apps/conf    | アプリケーション設定を格納                                                     |
| /apps/data    | アプリケーション用のデータファイル類を格納                                     |
| /apps/logs    | アプリケーションログを格納                                                     |
| /apps/src     | チェックアウトしたソースを格納 (※Jenkinsのチェックアウトディレクトリとは別物) |
| /apps/webapps | 各種Webアプリケーションのデプロイ用ディレクトリ                                |


## 3. 使用方法

1. [Vagrant](https://www.vagrantup.com/) 及び [VirtualBox](https://www.virtualbox.org/) をインストールする。

2. 本プロジェクトをcloneする。

3. 以下操作を実施する。  

	**[Windows]**  
	[init.bat](init.bat) を実行する。  

	**[その他OS]**  
	以下コマンドを実行する。  
  ```
  cd {本プロビジョニング環境ディレクトリ}
  vagrant plugin install vagrant-vbguest
  vagrant up
  ```


## 4. 注意点

### 5.1. IPアドレス設定
[Vagrantfile](Vagrantfile) の中でゲストOSのIPアドレスを固定値(192.168.33.11)で設定しているため、必要に応じて変更してください。

### 5.2. エラー発生時のログファイル確認
プロビジョニング実行時のログファイルはゲストOSの以下のパスに格納されます。  
エラーが発生した場合、コンソール表示内容またはログファイルを参照してください。

```
/home/vagrant/provision.<yyyymmddHHMMSS>.log
```
