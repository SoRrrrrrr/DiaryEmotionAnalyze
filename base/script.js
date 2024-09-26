// 이벤트 대상 선택: generateBtn이라는 이름의 ID를 가진 버튼 변수에 코드 저장
const generateBtn = document.querySelector('#generateBtn');
const gridContainer = document.querySelector('#gridContainer');

// 클릭 이벤트가 발생했을 때 실행할 코드
generateBtn.addEventListener('click', () => {
    // 콘솔에 메세지 출력 (테스트용) => cmd + opt + j 
    console.log('버튼을 누르면 진짜 이 함수가 실행되나 ?');

    // gridContainer 안에 포함된 자식 요소(이미지)의 개수가 30개 이상일 때
    if (gridContainer.children.length >= 30){
        // 확인 대화 상자 띄움
        const confirmed = confirm("이미지가 30개 찼습니다. 모든 사진을 지우겠습니까 ?")
        if (confirmed){ // true (OK) 인 경우
            //gridContainer 내부의 모든 HTML 내용을 삭제하여 현재 화면에 있는 모든 이미지 제거
            gridContainer.innerHTML = ""; 
        }else{
            // cancel을 누른 경우, 추가 작업을 중단한 
            return;
        }
    }
    // 랜덤 숫자 생성 (1에서 1000 사이의 숫자)
    const randomNum = Math.floor(Math.random() * 1000) + 1;
    // 랜덤 이미지 URL 생성 => API 사용
    const imageUrl = `https://picsum.photos/200/300?random=${randomNum}`;

    // 새로운 img 태그 생성
    const img = document.createElement('img');
    //외부 API 요청을 통해 받아온 데이터를 만들어진 이미지 태그의 src 속성에 넣는다 
    img.src = imageUrl; 
    //img.src =  `https://picsum.photos/200/300?random=${Math.floor(Math.random() * 1000) + 1}`;
    img.alt = '랜덤 이미지';
    
    // gridContainer에 이미지 추가(html file에서 태그 사이 멘트가 없는 이유)
    gridContainer.appendChild(img);
});
