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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.service.ClubService;
import org.zerock.service.UserService;
import org.zerock.domain.ClubDTO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	private final ClubService clubService;
	private final UserService userService;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model, HttpSession session, 
			@RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "category", required = false) String category,
            RedirectAttributes rttr) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		String loginUserEmail = (String) session.getAttribute("user_email");
		
		model.addAttribute("serverTime", formattedDate );
		
		model.addAttribute("loginUser", loginUserEmail);
		model.addAttribute("userName", userService.findName(loginUserEmail));
		
        List<String> categoryList = Arrays.asList(
                "전체", "공연·예술", "체육·레저", "학술·전공", "사회·봉사", "문화·교류",
                "창업·취업·자기개발", "취미·창작", "종교·인문", "기타"
        );
        model.addAttribute("categories", categoryList);
        model.addAttribute("selectedCategory", category);
        
        
        model.addAttribute("keyword", keyword);

        
        List<ClubDTO> clubList = clubService.searchClubs(keyword, category);
        model.addAttribute("clubList", clubList);
        
        
	    String email = (String) session.getAttribute("user_email");        
	    
	         
	    if (email != null) {
	        boolean hasClub = clubService.hasClub(email);
	        
	        model.addAttribute("userHasClub", hasClub); 
	    }
	    
	    
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

        
        model.addAttribute("categoryMap", categoryMap);
        
        
        
        model.addAttribute("selectedCategory", category);
        model.addAttribute("keyword", keyword);
	    
		return "home";
	}
	
}