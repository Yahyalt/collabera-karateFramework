package examples;

import io.karatelabs.junit6.Karate;

class ExamplesTest {
    @Karate.Test
    Karate testUsers() {
        return Karate.run("trial/users").relativeTo(getClass());
    }
}