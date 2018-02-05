package sh.calaba.appium.TestApp.test;

import com.microsoft.appcenter.appium.*;
import io.appium.java_client.MobileElement;
import org.junit.*;
import org.junit.rules.TestWatcher;
import org.junit.Rule;
import org.openqa.selenium.By;
import org.openqa.selenium.remote.DesiredCapabilities;

import java.net.URL;
import java.util.concurrent.TimeUnit;

import static org.junit.Assert.assertNotNull;

public class DylibInjectionTest {

  @Rule
  public TestWatcher watcher = Factory.createWatcher();

  private static EnhancedIOSDriver<MobileElement> driver;

  @Before
  public void before() throws Exception {
    String iosSampleApp = "https://path/to/DeviceAgent.iOS/TestApp.ipa";
    DesiredCapabilities capabilities = new DesiredCapabilities();
    capabilities.setCapability("platformName", "iOS");
    capabilities.setCapability("platformVersion", "10.1");
    capabilities.setCapability("deviceName", "");
    capabilities.setCapability("app", iosSampleApp);
    capabilities.setCapability("automationName", "XCUITest");

    String port = System.getProperty("port");
    if (port == null) {
      port = "4723";
    }

    URL url = new URL("http://localhost:" + port + "/wd/hub");
    driver = Factory.createIOSDriver(url, capabilities);
    driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
  }

  @After
  public void after() throws Exception {
    if (driver != null) {
      driver.quit();
    }
  }

  @Test
  public void testDylibInjection() throws Exception {
    driver.label("Given the app has launched");

    driver.findElement(By.id("Misc")).click();
    assertNotNull(driver.findElement(By.id("misc page")));
    driver.label("And I am looking at the Misc page");

    driver.findElement(By.id("gemuse me row")).click();
    assertNotNull(driver.findElement(By.id("gemuse me page")));
    driver.label("And I am looking at the Gemuse Me page");

    driver.label("When running in App Center, the entitlement injector is loaded");
    assertNotNull(driver.findElement(By.id("Tomato: promoted to vegetable")));

    // Only passed on Test Cloud / App Center
    driver.label("When running in App Center, the Gemuse Bouche libs are loaded");
    assertNotNull(driver.findElement(By.id("Beta Vulgaris")));
    assertNotNull(driver.findElement(By.id("Brassica")));
    assertNotNull(driver.findElement(By.id("Curcubits")));
  }
}
