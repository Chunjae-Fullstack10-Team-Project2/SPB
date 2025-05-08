package net.spb.spb.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

public class VideoUtil {

    public static String getVideoDuration(File videoFile) throws IOException {

        String[] command = {
                "ffprobe",
                "-v", "error",
                "-show_entries", "format=duration",
                "-of", "default=noprint_wrappers=1:nokey=1",
                videoFile.getAbsolutePath()
        };

        Process process = new ProcessBuilder(command).start();

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
            String durationStr = reader.readLine();
            if (durationStr != null) {
                double seconds = Double.parseDouble(durationStr);
                int totalSeconds = (int) Math.round(seconds);
                int minutes = totalSeconds / 60;
                int sec = totalSeconds % 60;
                return String.format("%02d:%02d", minutes, sec);
            }
        }

        return "00:00";
    }
}
