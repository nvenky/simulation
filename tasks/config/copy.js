/**
 * Copy files and folders.
 *
 * ---------------------------------------------------------------
 *
 * # dev task config
 * Copies all directories and files, exept coffescript and less fiels, from the sails
 * assets folder into the .tmp/public directory.
 *
 * # build task config
 * Copies all directories nd files from the .tmp/public directory into a www directory.
 *
 * For usage docs see:
 * 		https://github.com/gruntjs/grunt-contrib-copy
 */
module.exports = function(grunt) {

  grunt.config.set('copy', {
    dev: {
      files: [
      {
        expand: true,
        cwd: './assets',
        src: ['**/*.!(eot|svg|ttf|woff|otf)'],
        dest: '.tmp/public/assets'
      },
      {
        expand: true,
        flatten: true,
        cwd: './assets',
        src: ['**/*.{eot,svg,ttf,woff,otf}'],
        dest: '.tmp/public/assets/dependencies/fonts'
      },
      {
        expand: true,
        cwd: './assets/js',
        src: ['**/*.map'],
        dest: '.tmp/public/assets/js/'
      }
      ]
    },
    prod: {
      files: [{
        expand: true,
        flatten: true,
        cwd: './assets',
        src: ['**/*.{eot,svg,ttf,woff,otf}'],
        dest: '.tmp/public/assets/fonts'
      }]
    },
    build: {
      files: [{
        expand: true,
        cwd: '.tmp/public',
        src: ['**/*'],
        dest: 'www'
      }]
    }
  });

  grunt.loadNpmTasks('grunt-contrib-copy');
};
