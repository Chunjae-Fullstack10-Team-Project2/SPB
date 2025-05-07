package net.spb.spb.service.board;

import jakarta.servlet.ServletContext;
import net.spb.spb.dto.pagingsearch.PageRequestDTO;
import net.spb.spb.dto.pagingsearch.SearchDTO;
import net.spb.spb.mapper.BoardMapper;
import net.spb.spb.util.HttpUtil;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class NaverNewsService {
    @Autowired
    private ServletContext servletContext;

    @Autowired
    private BoardMapper boardMapper;

    public List<Map<String, Object>> searchNewsList(String query) throws Exception {
        String CLIENT_ID = servletContext.getInitParameter("naver.clientId");
        String CLIENT_SECRET = servletContext.getInitParameter("naver.clientSecret");

        if (query == null || query.trim().isEmpty()) {
            query = "네이버";
        }

        String encodedQuery = URLEncoder.encode(query, "UTF-8");
        String apiUrl = "https://openapi.naver.com/v1/search/news.json?query=" + encodedQuery + "&display=100&start=1&sort=date";

        String response = HttpUtil.get(apiUrl, CLIENT_ID, CLIENT_SECRET);
        JSONObject jsonResponse = new JSONObject(response);

        List<Map<String, Object>> result = new ArrayList<>();
        if (jsonResponse.has("items")) {
            JSONArray items = jsonResponse.getJSONArray("items");
            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                Map<String, Object> news = new HashMap<>();
                news.put("title", item.getString("title").replaceAll("<[^>]*>", "")
                        .replaceAll("&quot;", "\"")
                        .replaceAll("&lt;", "<")
                        .replaceAll("&gt;", ">")
                        .replaceAll("&amp;", "&"));
                news.put("link", item.getString("link"));
                news.put("description", item.getString("description").replaceAll("<[^>]*>", "")
                        .replaceAll("&quot;", "\"")
                        .replaceAll("&lt;", "<")
                        .replaceAll("&gt;", ">")
                        .replaceAll("&amp;", "&"));

                String pubDateStr = item.optString("pubDate");
                String formattedDate;
                try {
                    SimpleDateFormat inputFormat = new SimpleDateFormat("EEE, dd MMM yyyy HH:mm:ss Z", java.util.Locale.ENGLISH);
                    SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                    formattedDate = outputFormat.format(inputFormat.parse(pubDateStr));
                } catch (Exception e) {
                    formattedDate = pubDateStr;
                }
                news.put("pubDate", formattedDate);

                result.add(news);
            }
        }

        return result;
    }

}