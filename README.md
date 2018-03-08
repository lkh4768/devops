## 이 문서는 서버를 운영하며 있었던 이슈에 대해 기록하는 곳 입니다.



1. 메모리 적용 오류

물리적 메모리 32GB 지만 우분투에서 `$ cat /proc/meminfo` 했을 때는 16GB 로 표시됨.

=> BIOS 버그로 BIOS 초기화(BIOS 배터리 탈부착) 후 `$ cat /proc/meminfo` 32GB 정상으로 표시됨.



2. PAM service(sshd) ignoring max retries; 6 > 3

서버가 다운된 상태에서 다시 시작 후 journalctl을 살펴보니 아래와 같은 증상이 다수 있었다.

```shell
$ journalctl -f err
...
PAM service(sshd) ignoring max retries; 6 > 3
```

PEM에서 기본 인증(비밀번호) 재시도 횟수를 무시한다고 경고를 주는 로그다.

sshd의 인증 재시도 횟수는 기본적으로 6번에서 3번으로 수정했다.

```Sh
$ vi /etc/ssh/sshd_config

...

MaxAuthTries 3    ## 3으로 변경

...
```



3. kvm disabled by bios

```bash
$ vi /etc/modprobe.d/blacklist.conf
## 아래의 글 추가 ##
blacklist kvm
blacklist kvm_intel
blacklist kvm_amd
```



4. SP5100 address already in use

부팅 중 `SP5100 address already in use` 에러 출력

```bash
$ vi /etc/modprobe.d/blacklist.conf
## 아래의 글 추가 ##
blacklist sp5100_tco
```



5. fail2ban 설치

보안을 위해 무작위하게 ssh에 접속하는 아이피를 Ban하기 위해 [fail2ban 설치](https://github.com/lkh4768/devops/blob/master/install-fail2ban.sh)



6. 기본 언어 변경

```bash
$ vi /etc/default/locale
LANG="C" ## 기본으로 변경 ##

## 적용 ##
$ source /etc/default/locale
```



7. sudo 보안 취약점으로 인한 업그레이드

[sudo 보안 취약점 발견](http://www.zdnet.co.kr/news/news_view.asp?artice_id=20170606131340)

> SE리눅스가 켜진 시스템에서, 만일 어떤 사용자가 최상위 명령어 실행 권한을 얻지 못한 상태로 sudo 명령어를 사용하더라도, 이 취약점을 악용하면 파일시스템에 위치한 어떤 파일 내용이든 덮어쓸 수 있다. 최상위 관리자 권한 소유의 파일 내용도 조작될 수 있다는 얘기다.
> ...
> 이 취약점을 통한 공격이 작동하려면 사용자가 서버에 액세스할 수 있어야 하고 sudo 명령어를 실행할 수 있어야 한다고 덧붙였다. sudo 1.7.10부터 1.7.10p9 사이, sudo 1.8.5부터 1.8.20p1 사이 버전에 취약점이 존재한다.

[1.8.20p2 버전으로 업그레이드](https://github.com/lkh4768/devops/blob/master/upgrade_sudo.sh)



8. 임의의 기간 후에 서버 패닉 상태

증상으로는 

* 모니터 출력안됨
* ping은 되지만 telnet이 안됨

BIOS에서 RAM 전압을 원래 1.2V로 설정되어 있던 걸 권고 전압 1.35V로 수정하여 해결
