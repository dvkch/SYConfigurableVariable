Configurable Variable
=======

This Xcode plugin allows you to define build variables that you will be able to define easily via the Edit menu in Xcode.

![Screenshot](https://raw.githubusercontent.com/dvkch/SYConfigurableVariable/master/Sample%20screenshot%201.png)

Example
=======

You're making an app that can access multiple servers, say staging and production, and want to easily switch between those two without:
- having to edit a configuration file
- creating multiple targets or scheme
- modifying your build configuration

Using this plugin will make your life easier! Well, at least I hope so.

####Step 1: Install the plugin

It can either be done via [Alcatraz](http://alcatraz.io/) or by downloading the [GitHub project](github.com/dvkch/SYConfigurableVariable) and building it in Xcode which will automagically install the plugin.

####Step 2: Create a new configurable variable in your project

Open your project, then in Xcode go to: 

Edit > Configure build > Project > Target > New variable

Nota: If you have only one project in your workspace its name will not appear in the menu, you will directly be able to choose the target. Same thing goes for the targets: if there is only one you won't see its name appear in the menu.

A new dialog box opens. Enter the name for your configurable variable and its possible values, separated by semicolons. For our example we'll use `ENVIRONMENT` and `DEV;STAGING;PRODUCTION`.

####Step 3: Read the value of the variable

Create a config object, say SYConfig

<br />
SYConfig.h

	@interface SYConfig
	+ (NSString *)host;
	@end


SYConfig.m

	// little trick to convert a preprocessor macro string value to a C string
	#define str(s) #s
	#define xstr(s) str(s)
	
	// Possible cases
	typedef enum : NSUInteger {
	    SYConfigTypeUnknown,
	    SYConfigTypeDev,
	    SYConfigTypeStaging,
	    SYConfigTypeProduction,
	} SYConfigType;
	
	@implementation SYConfig
	
	// Determine the current environment
	+ (SYConfigType)configType
	{
	    NSString *varConfig = [NSString stringWithUTF8String:xstr(ENVIRONMENT)];
	    if ([varConfig isEqualToString:@"DEV"])         return SYConfigTypeDev;
	    if ([varConfig isEqualToString:@"STAGING"])     return SYConfigTypeStaging;
	    if ([varConfig isEqualToString:@"PRODUCTION"])  return SYConfigTypeProduction;
	    return SYConfigTypeUnknown;
	}
	
	// Determine host based on the current configuration
	+ (NSString *)host
	{
	    switch ([self configType]) {
	        case SYConfigTypeDev:        return @"https://dev.server.com";
	        case SYConfigTypeStaging:    return @"https://staging.server.com";
	        case SYConfigTypeProduction: return @"https://production.server.com";
	        case SYConfigTypeUnknown:    return @"Unknown server!";
	    }
	    return nil;
	}
	
	@end

####Step 4: Enjoy!

Now you'll be able to use the value of `+[SYConfig configType]` to determine the current build scenario. You can easily change the value of the `ENVIRONMENT` variable in Edit > Configure build > Project > Target > ENVIRONMENT > Debug/Example

Sample
=======

A sample project is available in this repository, as long as a video showing you the steps 1 through 4!

How does it work?
=======

To see how it works I'll explain how you can do the same thing by hand. I'll keep the variable name and values from our example above.

#####Creating a new configurable variable

1. Select your project in the Navigator tab in Xcode
2. Tap on the desired Target
3. Open Build Settings
4. Tap the `+` icon in the top toolbar, next to "Basic, All, Combined, Levels"
5. Select "Add User-Defined Setting"
6. Enter `ENVIRONMENT` for the name, and `DEV` for the value
7. Add a new User-Defined Setting (steps 4 & 5)
8. Enter `ENVIRONMENT_VALUES` for the name, and `DEV;STAGING;PRODUCTION` for the value
9. Head to "Preprocessor Macros"
10. For each build configuration add the item `ENVIRONMENT=$(ENVIRONMENT)`. Be careful, if the project value is empty (meaning it inherits the Project wide macros), add another line with the text `$(inherited)` to keep this behavior 

That's it. The `ENVIRONMENT` value will now be accessible in the project at build time, and `ENVIRONMENT_VALUES` will contain possible values for you to use as a reminder or to use with this tool.

#####Editing a variable

If you want to edit the list of possible values: modify the content of `ENVIRONMENT_VALUES` with you new set of values, delimited by semicolons.

If you want to edit the value of a variable: modify the content of `ENVIRONMENT` to the new value

Some rules
=======

Because nobody is perfect nor have the time to got close to it I didn't work on all the use cases, and though you're free to send me merge requests, for now the current limitations are:

- a variable is defined for a Target, not project-wide.
- you can't add/remove possible values for a variable with this tool, you'll have to manually edit the values user-defined setting in your target build configuration by hand
- using non-ASCII values have not been tested; I would not recommend using this tool to create a variable containing different URLs for instance
- a variable name must only contain the following characters: a-z, A-Z, 0-9 and `_`
- a variable can have a different value for each build configuration (for instance `DEV` for Debug, and `PRODUCTION` for Release)
- but a variable list of values must be the same accros all configurations in the Target
- if you remove the list of possible values, or the preprocessor macro definition, this toll won't recreate it, you'll need to do it by hand


License
======

Use it as you like in every project you want, redistribute with mentions of my name and don't blame me if it breaks :)

-- dvkch
 