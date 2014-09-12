module.exports = function (grunt) {
	grunt.registerTask('compileAssets', [
		'clean:dev',
		'jst:dev',
		'less:dev',
    'bower:install',
		'copy:dev',
		'coffee:dev'
	]);
};
