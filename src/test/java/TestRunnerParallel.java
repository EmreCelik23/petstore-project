import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class TestRunnerParallel {
    @Test
    public void testParallel(){
        Results result = Runner.path("classpath:features/PetTest.feature")
                .outputCucumberJson(true)
                .parallel(4);

        assertEquals(0, result.getFailCount(), result.getErrorMessages());
    }
}
