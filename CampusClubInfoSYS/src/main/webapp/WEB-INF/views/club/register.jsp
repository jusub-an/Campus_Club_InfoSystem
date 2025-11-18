<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>동아리 등록</title>
	<script>
        function validateForm() {
            // 폼 요소들을 가져옵니다.
            var form = document.forms[0];
            
            // 1. 이름 (club_name) 확인
            if (form.club_name.value.trim() === "") {
                alert("이름을 입력해 주세요.");
                form.club_name.focus();
                return false;
            }

            // 2. 카테고리 (category) 확인
            var categorySelected = false;
            var categoryRadios = form.category; // name="category"인 모든 radio 버튼
            for(var i = 0; i < categoryRadios.length; i++) {
                if(categoryRadios[i].checked) {
                    categorySelected = true;
                    break;
                }
            }
            if (!categorySelected) {
                alert("카테고리를 선택해 주세요.");
                return false;
            }
            
         	// 3. 로고 이미지 (logo_url) 확인
            if (form.description.value.trim() === "") {
                alert("로고 이미지를 등록해 주세요.");
                form.description.focus();
                return false;
            }
            
            // 4. 한줄 설명 (description) 확인
            if (form.description.value.trim() === "") {
                alert("한줄 설명을 입력해 주세요.");
                form.description.focus();
                return false;
            }

            // 5. 소개글 (introduction) 확인
            if (form.introduction.value.trim() === "") {
                alert("소개글을 입력해 주세요.");
                form.introduction.focus();
                return false;
            }

            // 모든 검사를 통과하면 true를 반환하여 폼이 제출됩니다.
            return true;
        }
    </script>
</head>
<body>
<h2>새 동아리 등록</h2>

<form action="/club/register" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
    이름: <input type="text" name="club_name" /><br>
    카테고리: <br>
    <div style="padding-left: 10px;">
        <input type="radio" name="category" value="공연·예술"> 🎭 1. 공연·예술<br>
        <input type="radio" name="category" value="체육·레저"> ⚽ 2. 체육·레저<br>
        <input type="radio" name="category" value="학술·전공"> 💻 3. 학술·전공<br>
        <input type="radio" name="category" value="사회·봉사"> 💬 4. 사회·봉사<br>
        <input type="radio" name="category" value="문화·교류"> 🌏 5. 문화·교류<br>
        <input type="radio" name="category" value="창업·취업·자기계발"> 💡 6. 창업·취업·자기계발<br>
        <input type="radio" name="category" value="취미·창작"> 🕹️ 7. 취미·창작<br>
        <input type="radio" name="category" value="종교·인문"> 🪩 8. 종교·인문<br>
        <input type="radio" name="category" value="기타"> 🧑‍🤝‍🧑 9. 기타<br>
    </div>
    <br>
    로고 이미지: <input type="file" name="logo_file" /><br>
    한줄 설명: <input type="text" name="description" /><br>
    소개글: <textarea name="introduction" rows="4" cols="40"></textarea><br>
    <input type="submit" value="등록" />
</form>

<a href="/club/list">목록으로 돌아가기</a>

</body>
</html>