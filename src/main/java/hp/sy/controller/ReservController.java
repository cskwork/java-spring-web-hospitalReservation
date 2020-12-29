package hp.sy.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import hp.Final.service.MypageService;
import hp.Final.service.ReservService;
import hp.common.common.CommandMap;

@Controller
@RequestMapping("/reserv")
public class ReservController {
	Logger log=Logger.getLogger(this.getClass());
	
	@Resource(name="reservService")
	private ReservService reservService;
	
	@Resource(name="mypageService")
	private MypageService mypageService;
	
	//예약하기 폼
	@RequestMapping("/OpenReserv")
	public String openReserv(CommandMap commandMap,Model model) throws Exception {
		model.addAttribute("map", commandMap.getMap().get("H_IDX"));
		model.addAttribute("body", "reserv");
		
		return "mainForm";
	}
	
	//예약가능한 병원명 목록 - json
	@RequestMapping("/SelectHospitalList")
	public String selectHpList(CommandMap commandMap,Model model) throws Exception{
	    List<Map<String,Object>> list = reservService.selectHpList(commandMap.getMap());
	    
	    model.addAttribute("list", list);

	    if(list.size()==0) {
	    	model.addAttribute("TOTAL", 0);
	    }
	    
	    return "jsonView";
	}
	
	//예약가능한 병원명에서 가능한 진료과목 목록 - json
	@RequestMapping("/SelectMajorList")
	public String selectMajorList(CommandMap commandMap,Model model) throws Exception{	    
	    List<Map<String,Object>> majorlist = reservService.selectHpList(commandMap.getMap());
	    model.addAttribute("list", majorlist);
	    
	    if(majorlist.size()==0) {
	    	model.addAttribute("MAJOR_TOTAL", 0);
	    }
	     
	    return "jsonView";
	}
	
	//달력 - json
	@RequestMapping("/SelectDate")
	public String selectDate(CommandMap commandMap,Model model) throws Exception{
	    
		model.addAttribute("H_IDX", commandMap.getMap().get("H_IDX"));
		model.addAttribute("HOSP", commandMap.getMap().get("HOSP"));
		model.addAttribute("MAJOR", commandMap.getMap().get("MAJOR"));
	    
	    return "jsonView";
	}
	
	//달력에서 선택한 예약일과 예약시간 - json
	@RequestMapping("/ReservDate")
	public String reservDate(CommandMap commandMap,Model model) throws Exception{
	    String year = (String)commandMap.getMap().get("year");
	    String month = (String)commandMap.getMap().get("month");
	    String day = (String)commandMap.getMap().get("day");	 
	    
	    List<String> timeList = reservService.selectDate(commandMap.getMap());
	    
	    model.addAttribute("H_IDX", commandMap.getMap().get("H_IDX"));//병원번호
	    model.addAttribute("HOSP", commandMap.getMap().get("HOSP"));//병원명
	    model.addAttribute("MAJOR", commandMap.getMap().get("MAJOR"));//진료과목
	    model.addAttribute("YEAR", year);//년
	    model.addAttribute("MONTH", month);//월
	    model.addAttribute("DAY", day);//일	    
	    model.addAttribute("TIMELIST", timeList);//시간	    	    
	    	    
	    return "jsonView";
	}
	
	//예약 확인창
	@RequestMapping("/ReservResult")
	public String reservResult(CommandMap commandMap,Model model) throws Exception{
	    String year = (String)commandMap.getMap().get("YEAR");
	    String month = (String)commandMap.getMap().get("MONTH");
	    String day = (String)commandMap.getMap().get("DAY");	 
	    String time = (String) commandMap.getMap().get("TIME");	 
	    
	    model.addAttribute("H_IDX", commandMap.getMap().get("H_IDX"));//병원번호
	    model.addAttribute("HOSP", commandMap.getMap().get("HOSP"));//병원명
	    model.addAttribute("MAJOR", commandMap.getMap().get("MAJOR"));//진료과목
	    model.addAttribute("YEAR", year);//년
	    model.addAttribute("MONTH", month);//월
	    model.addAttribute("DAY", day);//일	    
	    model.addAttribute("TIME", time);//시간
	    	    
	    return "jsonView";
	}
	
	//예약하기
	@RequestMapping("/Reservation")
	public String reservation(CommandMap commandMap, Model model, HttpSession session) throws Exception{
	    String year = (String)commandMap.getMap().get("YEAR");
	    String month = (String)commandMap.getMap().get("MONTH");
	    String day = (String)commandMap.getMap().get("DAY");	    
	    String reserv1 = year +"/"+ month +"/"+ day;	    
	    
	    commandMap.put("RESERV1", reserv1);
	   
	    model.addAttribute("STEP", commandMap.getMap().get("STEP"));
	    model.addAttribute("reservFalse", reservService.insertReserv(commandMap.getMap(), model, session));
	    	    
	    return "jsonView";
	}
	
	//예약 내역
	@RequestMapping("/MyReserv")
	public String myReserv(CommandMap commandMap, Model model, HttpSession session) throws Exception {
		List<Map<String, Object>> list=reservService.selectReservation(commandMap.getMap(), session);
		
		model.addAttribute("list", list);
		model.addAttribute("ID", session.getAttribute("ID"));
		model.addAttribute("STEP", commandMap.getMap().get("STEP"));//예약내역인지 지난예약내역인지 구분
		model.addAttribute("body", "mypageReservList");
		
		return "mainForm";
	}
	
	//지난예약 내역
	@RequestMapping("/MyPastReserv")
	public String myPastReserv(CommandMap commandMap, Model model, HttpSession session)throws Exception{
		List<Map<String, Object>> list = reservService.selectPastReservation(commandMap.getMap(), session);
		
		model.addAttribute("list", list);
		model.addAttribute("ID", session.getAttribute("ID"));
		model.addAttribute("STEP", commandMap.getMap().get("STEP"));//예약내역인지 지난예약내역인지 구분
		model.addAttribute("body", "mypageReservList");
		
		return "mainForm";
	}
	
	//예약 취소
	@RequestMapping("/CancelReserv")
	public String cancelReserv(CommandMap commandMap, Model model,  HttpSession session) throws Exception {
		model.addAttribute("ID", session.getAttribute("ID"));
		model.addAttribute("STEP", commandMap.getMap().get("STEP"));//예약내역인지 지난예약내역인지 구분
		
		reservService.cancelReserv(commandMap.getMap(), session);
		
		return "redirect:/reserv/MyReserv";
	}
	
	// 관리자-총 예약 목록
	@RequestMapping("/AdminReservList")
	public String AdminReservList(CommandMap commandMap, Model model, HttpSession session) throws Exception {
		List<Map<String, Object>> list = reservService.selectAdminReservList(commandMap.getMap(), model, session);
		
		model.addAttribute("list", list);
		
		if (list.size() > 0)
			model.addAttribute("TOTAL", list.get(0).get("TOTAL_COUNT"));
		else
			model.addAttribute("TOTAL", 0);
		
		return "jsonView";
	}
}
