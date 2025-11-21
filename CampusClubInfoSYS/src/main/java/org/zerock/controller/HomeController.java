package org.zerock.controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Map;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.service.ClubService;
import org.zerock.domain.ClubDTO;

import lombok.RequiredArgsConstructor;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequiredArgsConstructor
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	private final ClubService clubService;
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model, HttpSession session, 
			@RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "category", required = false) String category,
            RedirectAttributes rttr) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		model.addAttribute("loginUser", session.getAttribute("user_email"));
		
		// 동아리 카테고리 목록(화면에서 버튼으로 사용)
        List<String> categoryList = Arrays.asList(
                "전체", "공연·예술", "체육·레저", "학술·전공", "사회·봉사", "문화·교류",
                "창업·취업·자기개발", "취미·창작", "종교·인문", "기타"
        );
        model.addAttribute("categories", categoryList);
        model.addAttribute("selectedCategory", category);
        
        // 검색어 화면 유지
        model.addAttribute("keyword", keyword);

        // 동아리 검색 기능
        List<ClubDTO> clubList = clubService.searchClubs(keyword, category);
        model.addAttribute("clubList", clubList);
        
        // 동아리 등록 여부
	    String email = (String) session.getAttribute("user_email");        
	    
	    // 로그인한 경우에만 동아리 보유 여부 체크     
	    if (email != null) {
	        boolean hasClub = clubService.hasClub(email);
	        // JSP에서 판단하기 위해 결과를 모델에 담음
	        model.addAttribute("userHasClub", hasClub); 
	    }
	    
	    // 1. 카테고리 이름과 이미지 URL을 매핑한 Map 생성 (java.util.LinkedHashMap 사용 권장)
        // LinkedHashMap을 사용하면 등록한 순서대로 JSP에서 출력할 수 있습니다.
        Map<String, String> categoryMap = new java.util.LinkedHashMap<>();
        categoryMap.put("전체", "/resources/images/cat_all.png");
        categoryMap.put("공연·예술", "/resources/images/cat_art.jpg");
        categoryMap.put("체육·레저", "/resources/images/cat_sports.jpg");
        categoryMap.put("학술·전공", "/resources/images/cat_study.jpg");
        categoryMap.put("사회·봉사", "/resources/images/cat_volunteer.jpg");
        categoryMap.put("문화·교류", "/resources/images/cat_culture.jpg");
        categoryMap.put("창업·취업·자기계발", "/resources/images/cat_career.jpg");
        categoryMap.put("취미·창작", "/resources/images/cat_hobby.jpg");
        categoryMap.put("종교·인문", "/resources/images/cat_religion.jpg");
        categoryMap.put("기타", "/resources/images/cat_etc.jpg");

        // 2. Model에 categoryMap을 담아 JSP로 전달
        model.addAttribute("categoryMap", categoryMap);
        
        // 3. (기존 로직 유지) 검색/필터링을 위해 기존 변수들도 Model에 추가
        // home.jsp에서 c:forEach items="${categoryMap.keySet()}"를 사용하면 
        // 카테고리 목록(categories) 변수는 따로 넘기지 않아도 됩니다.

        model.addAttribute("selectedCategory", category);
        model.addAttribute("keyword", keyword);
	    
		return "home";
	}
	
}
