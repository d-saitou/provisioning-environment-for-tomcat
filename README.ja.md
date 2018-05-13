# Tomcat 8 アプリケーションプロビジョニング環境
\* [英語版](/README.md)

## 1. 概要
本プロジェクトは、Tomcat 8アプリケーション [(Spring4MvcExample)](https://github.com/d-saitou/Spring4MvcExample/) のプロビジョニング環境です。  
本プロビジョニング環境は以下の環境構築の操作を実行します。

* 仮想マシン構築
* ゲストOS及び必要なソフトウェア類のセットアップ
* アプリケーションのビルド/デプロイ
* データベース構築


## 2. 開発環境
以下の環境を使用して開発しています。

* Vagrant ~~1.9.8~~ \-> 2.1.1
* VirtualBox ~~5.1.26~~ \-> 5.2.12


## 3. 説明
本プロビジョニング環境は、プロビジョニングを実行するために以下のツールを使用しています。

* プロビジョニング
  - Vagrant (+シェルスクリプト)
  - Ansible (※プロビジョニング時にゲストOS内で自動インストール)
* ビルド/デプロイ
  - Maven (※プロビジョニング時にゲストOS内で自動インストール)
  - Jenkins (※プロビジョニング時にゲストOS内で自動インストール)

ゲストOSには CentOS 6 を使用します。  
また、Windows リモートデスクトップでゲストOSのデスクトップ環境に接続することができます。

### 3.1. セットアップ内容
本プロビジョニング環境は以下の手順でプロビジョニングを実行します。  

<div style="text-align: center;">
	<img src="https://github.com/d-saitou/provisioning-environment-for-tomcat8/blob/images/ProvisioningProcedure.ja.jpg">
</div>

### 3.2. ユーザ一覧
各種ユーザーのログイン情報は以下表の通りです。

**[OS]**

| ユーザー名 | パスワード | ホームディレクトリ | 備考                                |
|:-----------|:-----------|:-------------------|:------------------------------------|
| vagrant    | vagrant    | /home/vagrant      | Vagrant用仮想マシンのユーザー       |
| tomcat     | tomcat     | /apps              | Webアプリケーション起動用のユーザー |

**[アプリケーション]**

| アプリケーション  | ユーザー | パスワード | URL                                         | 備考         |
|:------------------|:---------|:-----------|:--------------------------------------------|:-------------|
| MySQL             | root     | root       | \-                                          |              |
| 〃                | spring   | spring     | ※ DB: spring4example                       |              |
| Tomcat Manager    | admin    | root       | http://{IPアドレス}:8080/manager/           |              |
| Jenkins           | admin    | root       | http://{IPアドレス}:8080/jenkins/           |              |
| Spring4MvcExample | admin    | admin      | http://{IPアドレス}:8080/Spring4MvcExample/ | 管理者       |
| 〃                | user     | user       | 〃                                          | 一般ユーザー |

### 3.3. ディレクトリ構成
各種Webアプリケーションは、"tomcat"ユーザーのホームディレクトリ配下に配置されます。  
ディレクトリ構成は以下の通りです。

| パス          | 説明                                                                           |
|:--------------|:-------------------------------------------------------------------------------|
| /opt/tomcat   | Tomcatインストールディレクトリ                                                 |
| /opt/maven    | Mavenインストールディレクトリ                                                  |
| /apps         | "tomcat"ユーザーのホームディレクトリ                                           |
| /apps/bin     | シェルスクリプト等の実行ファイルを格納                                         |
| /apps/conf    | アプリケーション設定を格納                                                     |
| /apps/data    | アプリケーション用のデータファイル類を格納                                     |
| /apps/logs    | アプリケーションログを格納                                                     |
| /apps/src     | チェックアウトしたソースを格納 (※Jenkinsのチェックアウトディレクトリとは別物) |
| /apps/tmp     | 一時的なファイルを格納するディレクトリ                                         |
| /apps/webapps | 各種Webアプリケーションのデプロイ用ディレクトリ                                |


## 4. 使用方法
以下の手順でプロビジョニングを実行してください。

1. [Vagrant](https://www.vagrantup.com/) 及び [VirtualBox](https://www.virtualbox.org/) をインストールする。

2. 本プロジェクトをチェックアウトする。

3. 以下ファイルを開き、必要に応じてバージョン及びダウンロード元URLを変更する。  

	* [/sync/provision/ansible/roles/mysql/defaults/main.yml](/sync/provision/ansible/roles/mysql/defaults/main.yml)  
	* [/sync/provision/ansible/roles/jdk/defaults/main.yml](/sync/provision/ansible/roles/jdk/defaults/main.yml)  
	* [/sync/provision/ansible/roles/maven/defaults/main.yml](/sync/provision/ansible/roles/maven/defaults/main.yml)  
	* [/sync/provision/ansible/roles/tomcat/defaults/main.yml](/sync/provision/ansible/roles/tomcat/defaults/main.yml)  
	* [/sync/provision/ansible/roles/jenkins/defaults/main.yml](/sync/provision/ansible/roles/jenkins/defaults/main.yml)  


4. 以下操作を実施する。  

	**[Windows]**  
	[startup.bat](startup.bat) を実行する。  

	**[その他OS]**  
	以下コマンドを実行する。  
  ```
  cd {本プロビジョニング環境ディレクトリ}
  vagrant plugin install vagrant-vbguest
  vagrant up
  ```


## 5. 注意点

### 5.1. IPアドレス設定
[Vagrantfile](Vagrantfile) の中でゲストOSのIPアドレスを固定値(192.168.33.11)で設定しているため、必要に応じて変更してください。

### 5.2. エラー発生時のログファイル確認
プロビジョニング実行時のログファイルはゲストOSの以下のパスに格納されます。  
エラーが発生した場合、コンソール表示内容またはログファイルを参照してください。

```
/home/vagrant/provision.<yyyymmddHHMMSS>.log
```

### 5.3. Tomcat再起動時のエラー終了
プロビジョニング中に何度かTomcatが再起動されますが、再起動に失敗してプロビジョニングがエラー終了する場合があります。  
この場合、ホストOS上で以下プロビジョニング再実行コマンドを実行すればプロビジョニングが成功します。  
※現在は原因不明。原因が解明した場合は修正予定。

```
vagrant provision
```

**エラー例:**
<div style="text-align: center;">
  <img src="https://github.com/d-saitou/provisioning-environment-for-tomcat8/blob/images/TomcatRestartError.jpg" width="95%">
</div>
