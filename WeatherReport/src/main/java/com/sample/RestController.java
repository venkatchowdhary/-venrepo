package com.sample;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RestController
public class RestController {

	private String final csvFilePath = "C:/Users/elangop/Desktop/personal/cities.csv";

	@RequestMapping(value = "loadCities", produces = MediaType.APPLICATION_JSON_VALUE)
	public String loadCities() {

		Map<String, String> map = new HashMap<>();
		File file = new File(csvFilePath);
		try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
			String line = reader.readLine();
			while (line != null) {
				String[] values = line.split(",");
				map.put(values[0], values[1]);
				line = reader.readLine();
			}
		} catch (Exception fe) {
		     fe.printStackTrace();	
		} 

		JSONObject obj = new JSONObject(map);
		return obj.toJSONString();
	}

	@RequestMapping(value ="loadLanguages", produces=MediaType.APPLICATION_JSON_VALUE)
	public String loadLanguages() {
		JSONObject obj = new JSONObject();
		obj.put("Arabic", "ar");
		obj.put("Bulgarian", "bg");
		obj.put("Catalan", "ca");
		obj.put("Czech", "cz");
		obj.put("German", "de");
		obj.put("Greek", "el");
		obj.put("English", "en");
		obj.put("Persian", "fa");
		obj.put("Finnish", "fi");
		obj.put("French", "fr");
		obj.put("Galician", "gl");
		obj.put("Croatian", "hr");
		obj.put("Hungarian", "hu");
		obj.put("Italian", "it");
		obj.put("Japanese", "ja");
		obj.put("Korean", "kr");
		obj.put("Latvian", "la");
		obj.put("Lithuanian", "lt");
		obj.put("Macedonian", "mk");
		obj.put("Dutch", "nl");
		obj.put("Polish", "pl");
		obj.put("Portuguese", "pt");
		obj.put("Romanian", "ro");
		obj.put("Russian", "ru");
		obj.put("Swedish", "se");
		obj.put("Slovak", "sk");
		obj.put("Slovenian", "sl");
		obj.put("Spanish", "es");
		obj.put("Turkish", "tr");
		obj.put("Ukrainian", "ua");
		obj.put("Vietnamese", "vi");
		obj.put("Chinese Simplified", "zh_cn");
		obj.put("Chinese Traditional", "zh_tw");
		return obj.toJSONString();
	}

}
