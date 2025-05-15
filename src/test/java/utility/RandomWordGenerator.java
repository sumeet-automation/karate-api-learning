package utility;

import java.util.Random;

public class RandomWordGenerator {

    // Method to generate a random word
    public static String generateWord(int length) {
        String alphabet = "abcdefghijklmnopqrstuvwxyz";
        StringBuilder word = new StringBuilder();
        Random random = new Random();

        for (int i = 0; i < length; i++) {
            int index = random.nextInt(alphabet.length());
            word.append(alphabet.charAt(index));
        }

        return word.toString();
    }

}