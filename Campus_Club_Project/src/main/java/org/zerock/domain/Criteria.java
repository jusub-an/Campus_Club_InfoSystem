package org.zerock.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;


@ToString
@Setter
@Getter
public class Criteria {

  private int pageNum;
  private int amount;
  
  private String type;
  private String keyword;
  
  // 1. post_type을 담을 필드 한 줄을 추가합니다.
  private String post_type;

  public Criteria() {
    this(1, 10);
  }

  public Criteria(int pageNum, int amount) {
    this.pageNum = pageNum;
    this.amount = amount; //한번에 보여줄 리스트 수
  }
  
  public String[] getTypeArr() {
    
    return type == null? new String[] {}: type.split("");
  }
}