import path from 'path';
import * as esbuild from 'esbuild'

const cssEntrypoints = [
  'assets/stylesheets/ui/bentries/home/index.css',
]

const cssOutbase = 'assets/stylesheets'

const jsEntrypoints = [
  'javascript/ui/bentries/home/index.js'
]
const jsOutbase = 'javascript'

const opt = {
  bundle: true,
  sourcemap: true,
  outdir: 'assets/builds',
  logLevel: 'info',
  absWorkingDir: path.join(process.cwd(), 'app'),
  loader: {
    '.css': 'css',
    '.js': 'js',
  },
}

let cssOpt = {
  ...opt,
  entryPoints: cssEntrypoints,
  outbase: cssOutbase,
}
let jsOpt = {
  ...opt,
  entryPoints: jsEntrypoints,
  outbase: jsOutbase,
}
if (process.argv.includes('--watch')) {
  esbuild.context(cssOpt)
    .then(ctx => {
      ctx.watch().then(() => console.log('watching css...'))
    })
    .catch(() => process.exit(1));
  
  esbuild.context(jsOpt)
    .then(ctx => {
      ctx.watch().then(() => console.log('watching js...'))
    })
    .catch(() => process.exit(1));
} else {
  esbuild.build(cssOpt).catch(() => process.exit(1));
  esbuild.build(jsOpt).catch(() => process.exit(1));
}