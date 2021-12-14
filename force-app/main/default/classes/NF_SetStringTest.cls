/**
 * Created by mcurry on 8/13/20.
 */

@IsTest
private class NF_SetStringTest {
    @IsTest
    static void testBehavior() {
        List<String> result = NF_SetString.setString(new List<String>{'test'});

        System.assertEquals(result[0], 'test');
    }
}