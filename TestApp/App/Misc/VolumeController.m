
#import "VolumeController.h"
#import <AVFoundation/AVFoundation.h>

@interface VolumeController ()
@property (weak, nonatomic) IBOutlet UILabel *currentVolume;
@property(nonatomic, strong) AVAudioSession *session;

@end

static NSString *const kCaVa = @"Ça va?";

@implementation VolumeController

- (void)viewDidLoad {
    [super viewDidLoad];


    NSError *audioSessionError = nil;
    self.session = [AVAudioSession sharedInstance];
    if (![self.session setCategory:AVAudioSessionCategoryPlayback error:&audioSessionError]) {
        if (audioSessionError) {
            NSLog(@"Error %@, %@",
                  @(audioSessionError.code), audioSessionError.localizedDescription);
        } else {
            NSLog(@"Failed to set audio sesson category but no error was generated");
        }

    } else {
        NSLog(@"Set audio session category to playback.");

        audioSessionError = nil;
        if (![self.session setActive:YES
                    withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                          error:&audioSessionError]) {
            if (audioSessionError) {
                NSLog(@"Error %@, %@",
                      @(audioSessionError.code), audioSessionError.localizedDescription);
            } else {
                NSLog(@"Failed to start audio session but no error was generated");
            }
        } else {
            NSLog(@"Started audio session");

            [self.session addObserver:self
                      forKeyPath:@"outputVolume"
                         options:0
                         context:nil];
        }
    }

    // Not being triggered.
    // Leaving so that someone else does not try this approach.
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleVolumeChanged:)
     name:@"AVSystemController_SystemVolumeDidChangeNotification"
     object:nil];

}

- (void)handleVolumeChanged:(NSNotification *)notification {
    NSNumber *number = [[notification userInfo]
                        objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"];
    NSLog(@"Volume changed notification: %@", number);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.session removeObserver:self forKeyPath:@"outputVolume"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

    if ([keyPath isEqual:@"outputVolume"]) {
        NSLog(@"volume changed: %@", @(self.session.outputVolume));
        self.currentVolume.text = [NSString stringWithFormat:@"%@",
                                   @(self.session.outputVolume)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.currentVolume.text = [NSString stringWithFormat:@"%@",
                               @(self.session.outputVolume)];
    [super viewWillAppear:animated];
}

@end
