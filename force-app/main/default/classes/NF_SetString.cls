/**
 * Created by samuel on 4/30/20.
 */

public with sharing class NF_SetString {
    @InvocableMethod(label='Neuraflash - Set String')
    public static List<String> setString(List<String> input) {
        String val = input.get(0);

        return new List<String>{val};


    }
}