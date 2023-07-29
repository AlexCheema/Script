
function mapAction(a) {
    if (a[0] == "1") {
        return {
            type: "Mint",
            tickLower: a[1],
            tickUpper: a[2],
            amount: a[3],
        }
    }

    if (a[0] == "2") {
        return {
            type: "Burn",
            tickLower: a[1],
            tickUpper: a[2],
            amount: a[3],
        }
    }

    return undefined;
}

function mapActions(rawActions) {
    return [...Array(rawActions.length / 4).keys()].map(i => mapAction(rawActions.slice(i*4, i*4 + 4))).filter(a => !!a);
}


module.exports.mapAction = mapAction;
module.exports.mapActions = mapActions;