/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package mai.ci.commandrecognizer;

/**
 *
 * @author javierfdr
 */
public class Main {
    public static void main(String[] args){
        SpectrogramRecognizer specRec = new SpectrogramRecognizer("../audiofiles/cierrate-alejandro.wav");
        MovingDescent movDesc = new MovingDescent(specRec.spec, (int) specRec.nsegs, specRec.seg_len);
        ImageTools.showSpecImage(specRec.spec,specRec.smax, specRec.smin, specRec.seg_len, (int)specRec.nsegs, specRec.mux, movDesc.getTonalLines());
    }
}
