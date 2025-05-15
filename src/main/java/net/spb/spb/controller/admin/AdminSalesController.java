package net.spb.spb.controller.admin;

import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import net.spb.spb.dto.OrderDTO;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.PageResponseDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.service.AdminService;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@Log4j2
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminSalesController extends AdminBaseController {

    private final AdminService adminService;

    @GetMapping("/sales/info")
    public String salesInfo(@ModelAttribute SearchDTO searchDTO,
                            @ModelAttribute PageRequestDTO pageRequestDTO,
                            Model model) {

        // 월별/강좌별 매출은 기존대로
        List<Map<String, Object>> monthlySales = adminService.getMonthlySales();
        List<Map<String, Object>> lectureSales = adminService.getLectureSales();

        // 개별 거래 내역 (조건 기반)
        List<OrderDTO> detailList = adminService.getSalesDetailList(searchDTO, pageRequestDTO);
        int count = adminService.getSalesDetailCount(searchDTO);

        PageResponseDTO<OrderDTO> pageResponseDTO = PageResponseDTO.<OrderDTO>withAll()
                .dtoList(detailList)
                .totalCount(count)
                .pageRequestDTO(pageRequestDTO)
                .build();

        model.addAttribute("monthlySales", monthlySales);
        model.addAttribute("lectureSales", lectureSales);
        model.addAttribute("searchDTO", searchDTO);
        model.addAttribute("responseDTO", pageResponseDTO);

        setBreadcrumb(model, Map.of("매출 정보", ""));
        return "/admin/sales/dashboard";
    }


    @GetMapping("/sales/monthly")
    @ResponseBody
    public List<Map<String, Object>> getMonthlySales(
            @RequestParam("timeType") String timeType,
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate
    ) {
        return adminService.getMonthlySales(timeType, startDate, endDate);
    }

    @GetMapping("/sales/lecture")
    @ResponseBody
    public List<Map<String, Object>> getLectureSales(
            @RequestParam("timeType") String timeType,
            @RequestParam("startDate") String startDate,
            @RequestParam("endDate") String endDate) {
        return adminService.getLectureSales(timeType, startDate, endDate);
    }

    @GetMapping("/sales/detail")
    @ResponseBody
    public PageResponseDTO<OrderDTO> salesDetailList(
            @RequestParam(value = "searchWord", required = false) String searchWord,
            @RequestParam(value = "searchType", required = false) String searchType,
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate,
            @RequestParam(value = "pageNo", defaultValue = "1") int pageNo,
            @RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
            @RequestParam(value = "sortColumn", required = false) String sortColumn,
            @RequestParam(value = "sortOrder", required = false) String sortOrder
    ) {
        SearchDTO searchDTO = new SearchDTO();
        searchDTO.setSearchWord(searchWord);
        searchDTO.setSearchType(searchType);
        searchDTO.setSortColumn(sortColumn);
        searchDTO.setSortOrder(sortOrder);
        searchDTO.setStartDate(startDate);
        searchDTO.setEndDate(endDate);

        PageRequestDTO pageRequestDTO = PageRequestDTO.builder()
                .pageNo(pageNo)
                .pageSize(pageSize)
                .build();

        List<OrderDTO> detailList = adminService.getSalesDetailList(searchDTO, pageRequestDTO);
        int count = adminService.getSalesDetailCount(searchDTO);

        return PageResponseDTO.<OrderDTO>withAll()
                .dtoList(detailList)
                .totalCount(count)
                .pageRequestDTO(pageRequestDTO)
                .build();
    }

    @GetMapping("/sales/export")
    public void exportSalesToExcel(
            @RequestParam(name = "searchType", required = false) String searchType,
            @RequestParam(name = "searchWord", required = false) String searchWord,
            @RequestParam(name = "startDate", required = false) String startDate,
            @RequestParam(name = "endDate", required = false) String endDate,
            HttpServletResponse response
    ) throws IOException {

        Map<String, Object> param = new HashMap<>();
        param.put("searchType", searchType);
        param.put("searchWord", searchWord);
        param.put("startDate", startDate);
        param.put("endDate", endDate);

        List<OrderDTO> list = adminService.getSalesListForExport(param);

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("매출 내역");

        Row header = sheet.createRow(0);
        header.createCell(0).setCellValue("주문번호");
        header.createCell(1).setCellValue("회원 ID");
        header.createCell(2).setCellValue("강좌명");
        header.createCell(3).setCellValue("금액");
        header.createCell(4).setCellValue("주문일");

        int rowNum = 1;
        for (OrderDTO row : list) {
            Row r = sheet.createRow(rowNum++);
            r.createCell(0).setCellValue(row.getOrderIdx());
            r.createCell(1).setCellValue(row.getOrderMemberId());
            r.createCell(2).setCellValue(row.getLectureTitle());
            r.createCell(3).setCellValue(row.getOrderAmount());
            r.createCell(4).setCellValue(row.getOrderCreatedAt().toString());
        }

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"sales.xlsx\"");

        workbook.write(response.getOutputStream());
        workbook.close();
    }

}
