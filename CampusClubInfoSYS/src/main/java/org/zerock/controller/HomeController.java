package org.zerock.controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;
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
	    
		return "home";
	}
	
}
