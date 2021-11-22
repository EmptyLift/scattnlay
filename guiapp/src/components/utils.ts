export function getModeName(i:number) {
    if (i == 1) return 'dipole'
    if (i == 2) return 'quadrupole'
    if (i == 3) return 'octupole'
    return  Math.pow(2, i).toString()
}

export function isAlmostSame(a:number,b:number) {
    if ( Math.abs((a-b)/(a+b)) < 1e-15) return true
    return false
}

export function range(start:number, stop:number, step = 1) {
    return Array(Math.round(((stop - start) / step)+1)).fill(start).map((x:number, y:number) => x + y * step)
}

export function rangeInt(size:number, startAt = 0) {
    return [...Array(size).keys()].map(i => i + startAt)
}

// convert value to nm from some units
export function fromUnits(fromU:string, val:number):number {
    if (fromU === 'nm') return val
    if (fromU === 'mkm') return val*1e3
    if (fromU === 'mm') return val*1e6
    if (fromU === 'cm') return val*1e7
    if (fromU === 'm') return val*1e9
    if (fromU === 'km') return val*1e12

    const c = 299792458 // m/s
    const hc = 1239841930.092394328e-15 // m*eV
    if (fromU === 'THz') return c/(val*1e12)*1e9
    if (fromU === 'GHz') return c/(val*1e9)*1e9
    if (fromU === 'MHz') return c/(val*1e6)*1e9
    if (fromU === 'kHz') return c/(val*1e3)*1e9
    if (fromU === 'Hz') return c/(val*1e0)*1e9

    if (fromU === 'eV') return hc/(val*1e0)*1e9
    if (fromU === 'meV') return hc/(val/1e3)*1e9

    if (fromU === 'fs') return (val/1e12)*c*1e9
    if (fromU === 'ps') return (val/1e15)*c*1e9

    return val
}

// convert value from nm to some units
export function toUnits(val:number, toU:string):number {
    if (toU === 'nm') return val
    if (toU === 'mkm') return val/1e3
    if (toU === 'mm') return val/1e6
    if (toU === 'cm') return val/1e7
    if (toU === 'm') return val/1e9
    if (toU === 'km') return val/1e12

    const c = 299792458 // m/s
    const hc = 1239841930.092394328e-15 // m*eV
    if (toU === 'THz') return c/(val/1e9)/1e12
    if (toU === 'GHz') return c/(val/1e9)/1e9
    if (toU === 'MHz') return c/(val/1e9)/1e6
    if (toU === 'kHz') return c/(val/1e9)/1e3
    if (toU === 'Hz') return c/(val/1e9)/1e0

    if (toU === 'eV') return hc/(val/1e9)
    if (toU === 'meV') return hc/(val/1e9)*1e3

    if (toU === 'fs') return (val/1e9)/c*1e12
    if (toU === 'ps') return (val/1e9)/c*1e15

    // if (fromU === 'eV') return hc/(val*1e0)*1e9
    // if (fromU === 'meV') return hc/(val/1e3)*1e9
    //
    // if (fromU === 'fs') return (val/1e12)/c*1e9
    // if (fromU === 'ps') return (val/1e15)/c*1e9
    return val
}
