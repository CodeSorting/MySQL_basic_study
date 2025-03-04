import pymysql
from tkinter import *
from tkinter import messagebox

## 데이터 삽입 함수
def insertData():
    con, cur = None, None  # 데이터베이스 연결 및 커서 변수 초기화
    data1, data2, data3, data4 = "", "", "", ""  # 입력 데이터 초기화
    sql = ""

    # MySQL 데이터베이스 연결 (로컬 서버 사용, soloDB 데이터베이스 선택)
    conn = pymysql.connect(host='127.0.0.1', user='root', password='0000', db='soloDB', charset='utf8')
    cur = conn.cursor()  # SQL 실행을 위한 커서 객체 생성

    # Entry 위젯에서 사용자 입력값 가져오기
    data1 = edt1.get()
    data2 = edt2.get()
    data3 = edt3.get()
    data4 = edt4.get()

    # SQL문을 문자열 연결 방식으로 구성 (보안상 취약점 존재, 개선 필요)
    sql = "INSERT INTO userTable VALUES('" + data1 + "','" + data2 + "','" + data3 + "'," + data4 + ")"
    cur.execute(sql)  # SQL 실행 (데이터 삽입)

    conn.commit()  # 변경 사항 저장
    conn.close()  # 데이터베이스 연결 종료

    # 성공 메시지 출력
    messagebox.showinfo('성공', '데이터 입력 성공')


## 데이터 조회 함수
def selectData():
    strData1, strData2, strData3, strData4 = [], [], [], []  # 조회된 데이터를 저장할 리스트

    # MySQL 데이터베이스 연결
    conn = pymysql.connect(host='127.0.0.1', user='root', password='0000', db='soloDB', charset='utf8')
    cur = conn.cursor()
    cur.execute("SELECT * FROM userTable")  # userTable의 모든 데이터 조회

    # 컬럼 제목 추가
    strData1.append("사용자 ID");      strData2.append("사용자 이름")
    strData3.append("사용자 이메일");   strData4.append("사용자 출생연도")
    strData1.append("-----------");    strData2.append("-----------")
    strData3.append("-----------");    strData4.append("-----------")

    # 조회된 데이터를 리스트에 추가
    while True:
        row = cur.fetchone()  # 한 행씩 가져오기
        if row is None:  # 더 이상 데이터가 없으면 반복 종료
            break
        strData1.append(row[0])
        strData2.append(row[1])
        strData3.append(row[2])
        strData4.append(row[3])

    # 기존 리스트 박스 데이터 삭제
    listData1.delete(0, listData1.size() - 1)
    listData2.delete(0, listData2.size() - 1)
    listData3.delete(0, listData3.size() - 1)
    listData4.delete(0, listData4.size() - 1)

    # 새로운 데이터 리스트 박스에 추가
    for item1, item2, item3, item4 in zip(strData1, strData2, strData3, strData4):
        listData1.insert(END, item1)
        listData2.insert(END, item2)
        listData3.insert(END, item3)
        listData4.insert(END, item4)

    conn.close()  # 데이터베이스 연결 종료


## 메인 GUI 코드
root = Tk()  # Tkinter 윈도우 생성
root.geometry("600x300")  # 창 크기 설정
root.title("완전한 GUI 응용 프로그램")  # 창 제목 설정

# 입력창이 위치할 프레임
edtFrame = Frame(root)
edtFrame.pack()

# 리스트 박스가 위치할 프레임 (아래쪽에 배치, 창 크기에 맞게 확장)
listFrame = Frame(root)
listFrame.pack(side=BOTTOM, fill=BOTH, expand=1)

# 사용자 입력을 위한 Entry 위젯 생성 (ID, 이름, 이메일, 출생연도)
edt1 = Entry(edtFrame, width=10)
edt1.pack(side=LEFT, padx=10, pady=10)

edt2 = Entry(edtFrame, width=10)
edt2.pack(side=LEFT, padx=10, pady=10)

edt3 = Entry(edtFrame, width=10)
edt3.pack(side=LEFT, padx=10, pady=10)

edt4 = Entry(edtFrame, width=10)
edt4.pack(side=LEFT, padx=10, pady=10)

# 데이터 입력 버튼 (insertData 함수 호출)
btnInsert = Button(edtFrame, text="입력", command=insertData)
btnInsert.pack(side=LEFT, padx=10, pady=10)

# 데이터 조회 버튼 (selectData 함수 호출)
btnSelect = Button(edtFrame, text="조회", command=selectData)
btnSelect.pack(side=LEFT, padx=10, pady=10)

# 데이터 출력을 위한 리스트 박스 4개 생성 (각각 ID, 이름, 이메일, 출생연도 표시)
listData1 = Listbox(listFrame, bg='yellow')  # 사용자 ID 리스트 박스
listData1.pack(side=LEFT, fill=BOTH, expand=1)

listData2 = Listbox(listFrame, bg='yellow')  # 사용자 이름 리스트 박스
listData2.pack(side=LEFT, fill=BOTH, expand=1)

listData3 = Listbox(listFrame, bg='yellow')  # 사용자 이메일 리스트 박스
listData3.pack(side=LEFT, fill=BOTH, expand=1)

listData4 = Listbox(listFrame, bg='yellow')  # 사용자 출생연도 리스트 박스
listData4.pack(side=LEFT, fill=BOTH, expand=1)

# Tkinter 이벤트 루프 실행
root.mainloop()
