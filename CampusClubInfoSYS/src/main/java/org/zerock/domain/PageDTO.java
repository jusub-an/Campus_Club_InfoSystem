package org.zerock.domain;

import lombok.Data;

@Data
public class PageDTO {

    // 페이지네이션 하단에 보여줄 페이지 버튼의 수 (1, 2, 3 ... 10)
    private int pageNumShow = 10;
    
    // 페이지 버튼의 시작 번호
    private int startPage;
    
    // 페이지 버튼의 끝 번호
    private int endPage;

    // "이전" 버튼 표시 여부
    private boolean prev;
    
    // "다음" 버튼 표시 여부
    private boolean next;

    // 게시물 총 개수
    private int total;
    
    // 현재 페이지 정보(pageNum, amount)를 가진 객체
    private Criteria cri;

    /**
     * 생성자.
     * Criteria와 total을 받아서 모든 페이지네이션 계산을 완료합니다.
     */
    public PageDTO(Criteria cri, int total) {
        this.cri = cri;
        this.total = total;

        // 1. endPage (보여질 끝 페이지 번호) 계산
        // 예: 현재 7페이지 -> 10, 현재 12페이지 -> 20
        this.endPage = (int) (Math.ceil(cri.getPageNum() / (double) this.pageNumShow)) * this.pageNumShow;

        // 2. startPage (보여질 시작 페이지 번호) 계산
        // 예: endPage가 10 -> 1, endPage가 20 -> 11
        this.startPage = this.endPage - (this.pageNumShow - 1);

        // 3. realEnd (데이터의 실제 마지막 페이지) 계산
        // 예: total 125개, amount 10 -> 13페이지
        int realEnd = (int) (Math.ceil((total * 1.0) / cri.getAmount()));

        // 4. endPage 보정
        // 만약 계산된 endPage(10)가 realEnd(8)보다 크면, endPage를 8로 설정
        if (realEnd < this.endPage) {
            this.endPage = realEnd;
        }

        // 5. prev (이전 버튼) 활성화 여부
        // startPage가 1보다 크면(즉, 11, 21...) true
        this.prev = this.startPage > 1;

        // 6. next (다음 버튼) 활성화 여부
        // realEnd가 endPage(10)보다 크면(즉, 11페이지 이상) true
        this.next = this.endPage < realEnd;
    }
}