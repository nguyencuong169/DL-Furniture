export function chainWebpack(config) {
  config.module
    .rule('html')
    .test(/\.html$/)
    .use('html-loader')
    .loader('html-loader')
}
// module.exports = {
//   publicPath: process.env.NODE_ENV === 'production' ? '/dl-furniture/' : '/'
// }
