package org.zerock.controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;
// 배열을 사용하기 위한 임포트
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

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model, HttpSession session) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		model.addAttribute("loginUser", session.getAttribute("user_email"));
		
		// 동아리 카테고리 목록(화면에서 버튼으로 사용)
        List<String> categoryList = Arrays.asList(
                "전체", "공연·예술", "체육·레저", "학술·전공", "사회·봉사", "문화·교류", "창업·취업·자기계발", "취미·창작", "종교·인문", "기타"
        );
        model.addAttribute("categories", categoryList);
		
		return "home";
	}
	
}
