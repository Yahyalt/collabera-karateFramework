package examples;

import io.karatelabs.junit6.Karate;

public class TaskCollaberaTest {
    @Karate.Test
    Karate testUsers() {
         return Karate.run("task/scenarioOne").relativeTo(getClass());
    }
}